import 'dart:async';

import 'package:flutter/material.dart';

import 'loginPage.dart';
import '../models/MarketTicker.dart';
import '../services/AuthService.dart';
import '../services/TickerService.dart';
import '../widgets/AssetsCarousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final TickerService _tickerService = TickerService();
  final TextEditingController _tickerController = TextEditingController();
  final TextEditingController _averagePriceController =
      TextEditingController();
  final List<PortfolioPosition> _positions = [];
  final Set<int> _deletingPositionIds = {};

  Timer? _searchTimer;
  List<MarketTicker> _suggestions = [];
  MarketTicker? _selectedTicker;
  String? _searchError;
  String? _portfolioError;
  String? _quoteError;
  bool _isSearching = false;
  bool _isRefreshing = false;
  bool _isLoadingPortfolio = true;
  bool _isSaving = false;
  int _searchGeneration = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPortfolio());
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _tickerController.dispose();
    _averagePriceController.dispose();
    super.dispose();
  }

  Future<void> _loadPortfolio() async {
    setState(() {
      _isLoadingPortfolio = true;
      _portfolioError = null;
    });

    try {
      final positions = await _tickerService.listarCarteira();
      if (!mounted) return;
      setState(() {
        _positions
          ..clear()
          ..addAll(positions);
        _isLoadingPortfolio = false;
      });
      if (positions.isNotEmpty) {
        await _refreshQuotes(showFailure: false);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingPortfolio = false;
        _portfolioError = 'Não foi possível carregar sua carteira.';
      });
    }
  }

  void _onTickerQueryChanged(String query) {
    _searchTimer?.cancel();
    final generation = ++_searchGeneration;
    final normalizedQuery = query.trim();

    setState(() {
      _selectedTicker = null;
      _suggestions = [];
      _searchError = null;
      _isSearching = normalizedQuery.length >= 2;
    });

    if (normalizedQuery.length < 2) return;
    _searchTimer = Timer(
      const Duration(milliseconds: 350),
      () => unawaited(_searchTickers(normalizedQuery, generation)),
    );
  }

  Future<void> _searchTickers(String query, int generation) async {
    try {
      final tickers = await _tickerService.buscarTickers(query);
      if (!mounted || generation != _searchGeneration) return;
      setState(() {
        _suggestions = tickers;
        _isSearching = false;
      });
    } catch (_) {
      if (!mounted || generation != _searchGeneration) return;
      setState(() {
        _isSearching = false;
        _searchError = 'Não foi possível buscar os tickers.';
      });
    }
  }

  void _selectTicker(MarketTicker ticker) {
    _searchGeneration++;
    setState(() {
      _selectedTicker = ticker;
      _tickerController.text = ticker.symbol;
      _suggestions = [];
      _searchError = null;
      _isSearching = false;
    });
  }

  void _retryTickerSearch() {
    final query = _tickerController.text.trim();
    if (query.length < 2) return;

    final generation = ++_searchGeneration;
    setState(() {
      _isSearching = true;
      _searchError = null;
    });
    unawaited(_searchTickers(query, generation));
  }

  Future<void> _addTicker() async {
    final ticker = _selectedTicker;
    final averagePrice = double.tryParse(
      _averagePriceController.text.trim().replaceAll(',', '.'),
    );

    if (ticker == null) {
      _showMessage('Escolha um ticker da lista de resultados.');
      return;
    }
    if (averagePrice == null || !averagePrice.isFinite || averagePrice <= 0) {
      _showMessage('Informe um preço médio válido.');
      return;
    }
    if (_positions.any(
      (position) => position.ticker.symbol == ticker.symbol,
    )) {
      _showMessage('${ticker.symbol} já está na sua carteira.');
      return;
    }

    setState(() => _isSaving = true);
    try {
      final savedPosition = await _tickerService.adicionarNaCarteira(
        symbol: ticker.symbol,
        averagePrice: averagePrice,
      );
      if (!mounted) return;
      setState(() {
        _positions.add(
          PortfolioPosition(
            id: savedPosition.id,
            ticker: ticker,
            averagePrice: savedPosition.averagePrice,
          ),
        );
        _selectedTicker = null;
        _tickerController.clear();
        _averagePriceController.clear();
        _suggestions = [];
        _quoteError = null;
      });
    } catch (_) {
      if (mounted) {
        _showMessage('Não foi possível salvar o ticker na sua carteira.');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _refreshQuotes({bool showFailure = true}) async {
    if (_positions.isEmpty || _isRefreshing) return;

    final positionsToRefresh = List<PortfolioPosition>.of(_positions);
    setState(() {
      _isRefreshing = true;
      _quoteError = null;
    });
    try {
      final updatedTickers = await Future.wait(
        positionsToRefresh.map(
          (position) => _tickerService.buscarTickerPorSimbolo(
            position.ticker.symbol,
          ),
        ),
      );
      if (!mounted) return;
      setState(() {
        final tickersBySymbol = {
          for (final ticker in updatedTickers) ticker.symbol: ticker,
        };
        for (var index = 0; index < _positions.length; index++) {
          final position = _positions[index];
          final ticker = tickersBySymbol[position.ticker.symbol];
          if (ticker != null) {
            _positions[index] = PortfolioPosition(
              id: position.id,
              ticker: ticker,
              averagePrice: position.averagePrice,
            );
          }
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _quoteError = 'Não foi possível atualizar as cotações.';
      });
      if (showFailure) _showMessage(_quoteError!);
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  Future<void> _removeTicker(PortfolioPosition position) async {
    setState(() => _deletingPositionIds.add(position.id));
    try {
      await _tickerService.removerDaCarteira(position.id);
      if (!mounted) return;
      setState(() {
        _positions.removeWhere((item) => item.id == position.id);
        _deletingPositionIds.remove(position.id);
      });
    } catch (_) {
      if (mounted) {
        _showMessage('Não foi possível remover o ticker da sua carteira.');
      }
    } finally {
      if (mounted) {
        setState(() => _deletingPositionIds.remove(position.id));
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('FinPa'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Abrir menu',
            onSelected: (value) async {
              if (value == 'logout') {
                await _authService.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false,
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Deslogar'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 760;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bem-vindo ao FinPa',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(height: 24),
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 4, child: _buildTickerForm()),
                        const SizedBox(width: 20),
                        Expanded(flex: 6, child: _buildPortfolio()),
                      ],
                    )
                  else ...[
                    _buildTickerForm(),
                    const SizedBox(height: 20),
                    _buildPortfolio(),
                  ],
                  const SizedBox(height: 28),
                  const Text(
                    'Ativos em destaque',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, carouselConstraints) {
                      final width = carouselConstraints.maxWidth < 340
                          ? carouselConstraints.maxWidth
                          : 340.0;
                      return Center(
                        child: SizedBox(
                          width: width,
                          child: const AssetsCarousel(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTickerForm() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Adicionar ativo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tickerController,
            enabled: !_isSaving,
            onChanged: _onTickerQueryChanged,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Buscar ticker',
              hintText: 'Ex.: PETR4',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          if (_isSearching)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: LinearProgressIndicator(),
            ),
          if (_searchError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _searchError!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                  TextButton(
                    onPressed: _retryTickerSearch,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          if (_suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, color: Colors.white12),
                itemBuilder: (context, index) {
                  final ticker = _suggestions[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      ticker.symbol,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      ticker.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () => _selectTicker(ticker),
                  );
                },
              ),
            ),
          if (!_isSearching &&
              _searchError == null &&
              _selectedTicker == null &&
              _suggestions.isEmpty &&
              _tickerController.text.trim().length >= 2)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'Nenhum ticker encontrado.',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          if (_selectedTicker != null) ...[
            const SizedBox(height: 8),
            Text(
              'Selecionado: ${_selectedTicker!.name}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _averagePriceController,
            enabled: !_isSaving,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Preço médio',
              hintText: '0,00',
              prefixText: 'R\$ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _selectedTicker == null || _isSaving ? null : _addTicker,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add),
            label: Text(
              _isSaving ? 'Salvando...' : 'Adicionar à carteira',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolio() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Minha carteira',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Atualizar cotações',
                onPressed:
                    _positions.isEmpty ||
                        _isRefreshing ||
                        _isLoadingPortfolio
                    ? null
                    : _refreshQuotes,
                icon: _isRefreshing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
              ),
            ],
          ),
          if (_quoteError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _quoteError!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          if (_isLoadingPortfolio)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_portfolioError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Text(
                    _portfolioError!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  TextButton(
                    onPressed: _loadPortfolio,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            )
          else if (_positions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Adicione um ticker para acompanhar seu preço médio e resultado.',
                style: TextStyle(color: Colors.white70),
              ),
            )
          else
            for (final position in _positions)
              _buildPositionCard(position),
        ],
      ),
    );
  }

  Widget _buildPositionCard(PortfolioPosition position) {
    final profit = position.profitPerShare;
    final profitColor = profit == null
        ? Colors.white70
        : profit >= 0
            ? Colors.greenAccent
            : Colors.redAccent;
    final profitLabel = profit == null
        ? 'Cotação indisponível'
        : '${profit >= 0 ? '+' : ''}${_formatCurrency(profit)} por ação/cota'
            ' (${position.returnPercent!.toStringAsFixed(2).replaceAll('.', ',')}%)';

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  position.ticker.symbol,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Remover ${position.ticker.symbol}',
                onPressed: _deletingPositionIds.contains(position.id)
                    ? null
                    : () => _removeTicker(position),
                icon: _deletingPositionIds.contains(position.id)
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_outline, size: 20),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          Text(
            position.ticker.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 4,
            children: [
              Text(
                'Preço médio: ${_formatCurrency(position.averagePrice)}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                position.ticker.lastPrice == null
                    ? 'Atual: indisponível'
                    : 'Atual: ${_formatCurrency(position.ticker.lastPrice!)}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            profitLabel,
            style: TextStyle(
              color: profitColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: child,
    );
  }
}
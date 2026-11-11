import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/Asset.dart';
import '../services/AssetService.dart';

class AssetsCarousel extends StatefulWidget {
  const AssetsCarousel({super.key});

  @override
  State<AssetsCarousel> createState() => _AssetsCarouselState();
}

class _AssetsCarouselState extends State<AssetsCarousel> {
  final AssetService _assetService = AssetService();
  final PageController _pageController = PageController();
  final List<Asset> _assets = [];

  late final Timer _rotationTimer;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadAssets());
    _rotationTimer = Timer.periodic(const Duration(seconds: 9), (_) {
      if (!_pageController.hasClients || _assets.length <= 2) return;

      final pageCount = (_assets.length + 1) ~/ 2;
      final currentPage = _pageController.page?.round() ?? 0;
      unawaited(
        _pageController.animateToPage(
          (currentPage + 1) % pageCount,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        ),
      );
    });
  }

  Future<void> _loadAssets() async {
    try {
      final assets = await _assetService.buscarAtivos();
      if (!mounted) return;
      setState(() {
        _assets
          ..clear()
          ..addAll(assets);
        _errorMessage = null;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Não foi possível carregar os ativos: $error';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _rotationTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 132,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage case final message?) {
      return SizedBox(
        height: 132,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  unawaited(_loadAssets());
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_assets.isEmpty) {
      return const SizedBox(
        height: 132,
        child: Center(
          child: Text(
            'Nenhum ativo encontrado.',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final pageCount = (_assets.length + 1) ~/ 2;
    return SizedBox(
      height: 132,
      child: PageView.builder(
        controller: _pageController,
        itemCount: pageCount,
        itemBuilder: (context, pageIndex) {
          final firstIndex = pageIndex * 2;
          final lastIndex = firstIndex + 2 < _assets.length
              ? firstIndex + 2
              : _assets.length;
          final pageAssets = _assets.sublist(firstIndex, lastIndex);

          return Row(
            children: [
              for (var index = 0; index < pageAssets.length; index++) ...[
                if (index > 0) const SizedBox(width: 12),
                Expanded(child: _AssetCard(asset: pageAssets[index])),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AssetCard extends StatelessWidget {
  const _AssetCard({required this.asset});

  final Asset asset;

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _AssetLogo(url: asset.logoUrl),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  asset.symbol,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            asset.longName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
          Text(
            'R\$ ${asset.regularMarketPrice.toStringAsFixed(2)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetLogo extends StatelessWidget {
  const _AssetLogo({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(url);
    final isSvg = uri?.path.toLowerCase().endsWith('.svg') ?? false;
    final fallback = Icon(
      Icons.show_chart,
      size: 20,
      color: Theme.of(context).colorScheme.primary,
    );

    if (uri == null || !uri.hasScheme) return fallback;

    final image = isSvg
        ? SvgPicture.network(
            url,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => fallback,
          )
        : Image.network(
            url,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => fallback,
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        width: 30,
        height: 30,
        child: image,
      ),
    );
  }
}

package com.backend.mobile;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.time.Instant;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.security.oauth2.jwt.JwsHeader;

@SpringBootTest(properties = "app.jwt.secret=test-secret-with-at-least-32-characters")
class MobileApplicationTests {

	@Autowired
	private JwtEncoder jwtEncoder;

	@Autowired
	private JwtDecoder jwtDecoder;

	@Test
	void contextLoads() {
	}

	@Test
	void jwtRoundTripPreservesUserIdentity() {
		Instant now = Instant.now();
		JwtClaimsSet claims = JwtClaimsSet.builder()
			.issuedAt(now)
			.expiresAt(now.plusSeconds(60))
			.subject("yuri@example.com")
			.claim("userId", "42")
			.build();
		String token = jwtEncoder.encode(JwtEncoderParameters.from(
			JwsHeader.with(MacAlgorithm.HS256).build(),
			claims
		)).getTokenValue();

		Jwt decoded = jwtDecoder.decode(token);

		assertEquals("yuri@example.com", decoded.getSubject());
		assertEquals("42", decoded.getClaimAsString("userId"));
	}
}

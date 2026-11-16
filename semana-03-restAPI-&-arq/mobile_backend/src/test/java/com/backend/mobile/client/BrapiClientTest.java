package com.backend.mobile.client;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;

import tools.jackson.databind.JsonNode;

class BrapiClientTest {

    @Test
    void searchesTickersThroughBrapiAndReturnsTheApiResponse() {
        RestClient.Builder builder = RestClient.builder();
        MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
        BrapiClient client = new BrapiClient(
            builder,
            "https://brapi.dev/api",
            "test-token"
        );
        server.expect(requestTo(
                "https://brapi.dev/api/v2/tickers?search=PETR4&limit=10"
            ))
            .andRespond(withSuccess(
                """
                {"results":[{"symbol":"PETR4","quote":{"lastPrice":38.25}}]}
                """,
                MediaType.APPLICATION_JSON
            ));

        JsonNode response = client.getTickers(" PETR4 ");

        assertEquals("PETR4", response.path("results").get(0).path("symbol").asText());
        server.verify();
    }
}

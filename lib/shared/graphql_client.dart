import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../providers.dart';

class AppGraphQLClient {
  static const String graphQLServerURL = 'http://3.131.69.3:8001/v1/graphql';
  static const Duration queryTimeout = Duration(seconds: 10);
  static late GraphQLClient _client;

  AppGraphQLClient(ProviderRef<AppGraphQLClient> ref) {
    User? user = ref.read(firebaseAuthProvider).currentUser;
    final HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final HttpLink httpLink = HttpLink(
      graphQLServerURL,
      httpClient: IOClient(httpClient),
    );
    final AuthLink authLink = AuthLink(
      getToken: () async {
        String token;
        final IdTokenResult? idTokenResult = await user?.getIdTokenResult();
        final hasuraClaims =
            idTokenResult?.claims?["https://hasura.io/jwt/claims"];
        if (hasuraClaims != null) {
          token = await user!.getIdToken();
          return 'Bearer $token';
        }
        token = await user!.getIdToken(true);
        return 'Bearer $token';
      },
    );
    final Link link = authLink.concat(httpLink);
    _client = GraphQLClient(link: link, cache: GraphQLCache());
  }

  Future<QueryResult> query(
      {required String query, Map<String, dynamic>? variables}) async {
    try {
      final QueryOptions options = QueryOptions(
          document: gql(query),
          variables: variables ?? {},
          fetchPolicy: FetchPolicy.networkOnly);
      final QueryResult result =
          await _client.query(options).timeout(queryTimeout);
      if (result.hasException) {
        throw Exception(result.exception);
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<QueryResult> mutate(
      {required String query, Map<String, dynamic>? variables}) async {
    try {
      final MutationOptions options = MutationOptions(
          document: gql(query),
          variables: variables ?? {},
          fetchPolicy: FetchPolicy.networkOnly);
      final QueryResult result =
          await _client.mutate(options).timeout(queryTimeout);
      if (result.hasException) {
        throw Exception(result.exception);
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }
}

final graphQLProvider = Provider<AppGraphQLClient>((ref) {
  return AppGraphQLClient(ref);
});

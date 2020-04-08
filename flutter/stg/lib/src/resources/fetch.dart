import 'dart:convert';
import 'package:graphql/client.dart';
import '../models/user.dart';

class FetchFromSTGWithGraphql {
  fetchGraphql(String request) async {
    final HttpLink _httpLink = HttpLink(
      uri: 'http://192.168.86.44:5000/graphql',
    );

    final AuthLink _authLink = AuthLink(
      getToken: () async =>
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlNWMyZTA0ODljNmQ5OTczOWY5NmQ0MiIsImV4cCI6MTU4Mzc5MTYyNCwiaWF0IjoxNTgzNzkxMDI0fQ.OB9_ObJdH9r3VyVjSqTO_DU_CBG7ILg-1seKmnKIOgk',
    );

    final Link _link = _authLink.concat(_httpLink);

    final GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: _link,
    );

    final QueryOptions options = QueryOptions(
      documentNode: gql(request),
      variables: {},
    );

    final QueryResult result = await _client.query(options);

    if (result.hasException) {
      print(result.exception.toString());
    }

    print(result.data);
  }
}

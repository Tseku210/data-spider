import 'package:flutter_dotenv/flutter_dotenv.dart';

const List<String> cashTypeList = <String>[
  '50₮',
  '100₮',
  '500₮',
  '1000₮',
  '5000₮',
  '10000₮',
  '20000₮'
];

var cognitoDomain = dotenv.env['COGNITO_DOMAIN'];
var cognitoClientId = dotenv.env['COGNITO_CLIENT_ID'];
var cognitoRegion = dotenv.env['COGNITO_REGION'];
var cognitoRedirectUri = dotenv.env['COGNITO_REDIRECT_URI'];
var apiGatewayUrl = dotenv.env['API_GATEWAY_URL'];
var s3BucketName = dotenv.env['S3_BUCKET_NAME'];

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/core/models/ChatApiResponse.dart';
import 'package:paitent/networking/ChatApiProvider.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/StringUtility.dart';

import '../base_model.dart';

class BotViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ChatApiProvider apiProvider = GetIt.instance<ChatApiProvider>();

  String clientName = 'REAN_BOT';

  Future<ChatApiResponse> sendMsgApi(Map body) async {
    if (getAppType() == 'AHA') {
      clientName = getAppType();
    }

    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;
    map['authentication'] = dotenv.env['BOT_HEADER_TOKEN'];

    final response = await apiProvider.post(
        '/' +
            clientName +
            '/REAN_SUPPORT/' +
            dotenv.env['BOT_URL_TOKEN'] +
            '/receive',
        header: map,
        body: body);

    setBusy(false);
    // Convert and return
    return ChatApiResponse.fromJson(response);
  }
}

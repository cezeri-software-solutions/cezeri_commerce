import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
final logger = Logger();

class Constants {
  static const String authorizationServerKey =
      'AAAA_y82iTQ:APA91bHtQg3_a6ODRYo_rD5UFiA2NK2ZJVUZUBMkN650CDxudghd8SZi4-r4LPIOG5DQqsGqCS1_kmZnm3K1UQjk7cxbHF-hjhOfazjB-gf8KTUq7A266sovRsY9qoIlQFzpc6W2Zu53';
}

//* FixSizes
class FixSizes {
  FixSizes._();

  static const double persistantWidth = 800;
  static const double drawerWidth = 240;
}

class TextStyles {
  TextStyles._();

  static const TextStyle h1 = TextStyle(fontSize: 32);
  static const TextStyle h2 = TextStyle(fontSize: 22);
  static const TextStyle h2Bold = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  static const TextStyle h3 = TextStyle(fontSize: 16);
  static const TextStyle h3Bold = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const TextStyle h3BoldPrimary = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.primaryColor);
  static const TextStyle defaultt = TextStyle(fontSize: 14);
  static const TextStyle defaultBold = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static const TextStyle defaultBoldPrimary = TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CustomColors.primaryColor);
  static const TextStyle buttonText = TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
  static const TextStyle textButtonText = TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF006399));
  static const TextStyle listTile = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static const TextStyle dateTime = TextStyle(fontSize: 11, color: Color(0xFF42474E));

  static const TextStyle s8 = TextStyle(fontSize: 8);
  static const TextStyle s10 = TextStyle(fontSize: 10);
  static const TextStyle s12 = TextStyle(fontSize: 12);
  static const TextStyle s12Bold = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
  static const TextStyle s13 = TextStyle(fontSize: 13);
  static const TextStyle s13Bold = TextStyle(fontSize: 13, fontWeight: FontWeight.bold);

  static const TextStyle modalHeadTitle = TextStyle(fontSize: 30);

  static const TextStyle appBarSubtitle = TextStyle(fontSize: 15);

  static const TextStyle infoOnTextField = TextStyle(color: Colors.grey);
  static const TextStyle infoOnTextFieldSmall = TextStyle(color: Colors.grey, fontSize: 12);
}

class CustomColors {
  CustomColors._();

  //* Theme Colors
  static const primaryColor = Color(0xFF64A0C8);

  static const Color containerBackgroundLight = Colors.white;
  static const Color containerBackgroundDark = Color.fromARGB(255, 66, 66, 66);

  static const Color backgroundLightGrey = Color.fromARGB(255, 230, 230, 230);
  static const Color backgroundLightGreen = Color.fromARGB(255, 167, 251, 174);
  static const Color backgroundLightOrange = Color.fromARGB(255, 255, 200, 50);

  static const Color ultraLightBlue = Color.fromARGB(255, 229, 244, 251);
  static const Color ultraLightOrange = Color.fromARGB(255, 250, 240, 200);
  static const Color ultraLightOrange2 = Color.fromARGB(255, 255, 226, 110);
  static const Color ultraLightGreen = Color.fromARGB(255, 210, 255, 215);
  static const Color ultraLightGrey = Color.fromARGB(255, 242, 242, 242);
  static const Color ultraLightYellow = Color.fromARGB(255, 255, 245, 160);
  static const Color ultraLightRed = Color.fromARGB(255, 255, 214, 210);

  static const Color borderColorLight = Color.fromARGB(255, 224, 224, 224);
  static const Color borderColorDark = Color.fromARGB(255, 80, 80, 80);

  static const Color iconColor = Color.fromARGB(255, 120, 120, 120);
  static const Color iconPrimaryColor = primaryColor;
  static const Color iconDisabledColor = Color.fromARGB(255, 180, 180, 180);

  static const Color bottomNavTextActive = primaryColor;
  static const Color bottomNavTextDisabled = Color.fromARGB(255, 160, 160, 160);

  //* Custom Colors
  static const Color avatarBackgroundColor = Color.fromARGB(255, 190, 190, 190);

  static const Color chipSelectedColor = primaryColor;
  static const Color chipBackgroundColor = Color.fromARGB(255, 225, 245, 254);

  static const Color todoScaleGreenActive = Colors.green;
  static const Color todoScaleGreenDisabled = Color.fromARGB(255, 232, 245, 233);
  static const Color todoScaleYellowActive = Colors.yellow;
  static const Color todoScaleYellowDisabled = Color.fromARGB(255, 255, 253, 231);
  static const Color todoScalePurpleActive = Colors.orange;
  static const Color todoScalePurpleDisabled = Color.fromARGB(255, 255, 243, 224);
  static const Color todoScaleRedActive = Colors.red;
  static const Color todoScaleRedDisabled = Color.fromARGB(255, 255, 235, 238);

  //* Chart Colors
  static const Color chartColorCyan = Color.fromARGB(255, 80, 228, 255);
  static const Color chartColorBlue = Color.fromARGB(255, 33, 150, 243);
  static const Color chartColorYellow = Color.fromARGB(255, 255, 195, 0);
  static const Color chartColorRed = Color.fromARGB(255, 232, 0, 84);
  static const Color chartColorOrange = Color(0xFFFF683B);
}

class Gaps {
  Gaps._();

  static const SizedBox h2 = SizedBox(height: 2);
  static const SizedBox h4 = SizedBox(height: 4);
  static const SizedBox h8 = SizedBox(height: 8);
  static const SizedBox h10 = SizedBox(height: 10);
  static const SizedBox h12 = SizedBox(height: 12);
  static const SizedBox h14 = SizedBox(height: 14);
  static const SizedBox h16 = SizedBox(height: 16);
  static const SizedBox h24 = SizedBox(height: 24);
  static const SizedBox h32 = SizedBox(height: 32);
  static const SizedBox h42 = SizedBox(height: 42);
  static const SizedBox h54 = SizedBox(height: 54);

  static const SizedBox w2 = SizedBox(width: 2);
  static const SizedBox w4 = SizedBox(width: 4);
  static const SizedBox w8 = SizedBox(width: 8);
  static const SizedBox w10 = SizedBox(width: 10);
  static const SizedBox w12 = SizedBox(width: 12);
  static const SizedBox w16 = SizedBox(width: 16);
  static const SizedBox w24 = SizedBox(width: 24);
  static const SizedBox w32 = SizedBox(width: 32);
}

//* ProductsOverviewPage
class RWPP {
  RWPP._();

  static const double picture = 70;
  static const double prices = 150;
}

//* ProductsOverviewPage Mobile
class RWMBPP {
  RWMBPP._();

  static const double picture = 50;
  static const double prices = 120;
}

//* ReceiptsOverviewPage
class RWROP {
  RWROP._();

  static const int pos = 30;
  static const int articleNumber = 160;
  static const int ean = 140;
  static const int articleName = 600;
  static const int openQuantity = 50;
  static const int quantity = 54;
}

//* ReorderDetailProductsCard
class RWReOP {
  RWReOP._();

  static const int pos = 30;
  static const int articleNumber = 160;
  static const int articleName = 600;
  static const int quantity = 50;
  static const int openQuantity = 50;
  static const int price = 55;
  static const int totalPrice = 55;
}

//* ReceiptDetailProductsCard
class RWRDP {
  RWRDP._();

  static const int articleNumber = 100;
  static const int articleName = 400;
  static const int tax = 120;
  static const int quantity = 50;
  static const int unitPriceNet = 80;
  static const int discountGrossUnit = 80;
  static const int unitPriceGross = 80;
  static const int totalPriceGross = 80;
}

//* IncomingInvoicesOverview
class RWIIO {
  RWIIO._();

  static const int incomingInvoiceNumber = 120;
  static const int supplierNumber = 120;
  static const int supplierName = 340;
  static const int invoiceNumber = 120;
  static const int invoiceDate = 90;
  static const int bookingDate = 90;
  static const int amount = 90;
  static const int status = 120;
}

class HeaderSpace {
  HeaderSpace._();

  //static double header1(double screenHeight) => screenHeight * 0.95;
  //static double header2(double screenHeight) => screenHeight * 0.93;
  //static double header3(double screenHeight) => screenHeight * 0.91;
  //static double header60p(double screenHeight) => screenHeight * 0.6;
  //static double header50p(double screenHeight) => screenHeight * 0.5;

  static const double header1 = 0.95;
  static const double header2 = 0.93;
  static const double header3 = 0.91;
  static const double header60p = 0.6;
  static const double header50p = 0.5;
}

class OutlinedButtonStyle {
  OutlinedButtonStyle._();

  static final ButtonStyle filled = OutlinedButton.styleFrom(
    minimumSize: const Size(100.0, 36.0),
    backgroundColor: CustomColors.primaryColor,
    foregroundColor: Colors.white,
  );
}

InputDecoration borderDecoration(String labelText) => InputDecoration(
      labelText: labelText,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(width: 1, color: Colors.grey),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(width: 1, color: CustomColors.primaryColor),
      ),
      contentPadding: EdgeInsets.zero,
      fillColor: Colors.white,
      focusColor: Colors.purple,
      hoverColor: Colors.yellow,
    );

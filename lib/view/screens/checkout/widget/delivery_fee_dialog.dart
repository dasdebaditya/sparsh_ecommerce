import 'package:sparsh_user/helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:sparsh_user/helper/price_converter.dart';
import 'package:sparsh_user/localization/language_constrants.dart';
import 'package:sparsh_user/provider/order_provider.dart';
import 'package:sparsh_user/provider/splash_provider.dart';
import 'package:sparsh_user/utill/dimensions.dart';
import 'package:sparsh_user/utill/styles.dart';
import 'package:sparsh_user/view/base/custom_button.dart';
import 'package:sparsh_user/view/base/custom_divider.dart';
import 'package:provider/provider.dart';

class DeliveryFeeDialog extends StatelessWidget {
  final double amount;
  final double distance;
  DeliveryFeeDialog({@required this.amount, @required this.distance});

  @override
  Widget build(BuildContext context) {
    double _deliveryCharge = distance
        * Provider.of<SplashProvider>(context, listen: false).configModel.deliveryManagement.shippingPerKm;
    if(_deliveryCharge < Provider.of<SplashProvider>(context, listen: false).configModel.deliveryManagement.minShippingCharge) {
      _deliveryCharge = Provider.of<SplashProvider>(context, listen: false).configModel.deliveryManagement.minShippingCharge;
    }

    return Container(
      padding:  EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ?  300 : 0),
      child: Consumer<OrderProvider>(builder: (context, order, child) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Column( mainAxisSize: MainAxisSize.min, children: [

              Container(
                height: 70, width: 70,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delivery_dining,
                  color: Theme.of(context).primaryColor, size: 50,
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Column(children: [
                Text(
                  getTranslated('delivery_fee_from_your_selected_address_to_branch', context)+':',
                  style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE), textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                Text(
                  PriceConverter.convertPrice(context, _deliveryCharge),
                  style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                ),

                SizedBox(height: 20),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(getTranslated('subtotal', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                  Text(PriceConverter.convertPrice(context, amount), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ]),
                SizedBox(height: 10),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    getTranslated('delivery_fee', context),
                    style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                  ),
                  Text(
                    '(+) ${PriceConverter.convertPrice(context, _deliveryCharge)}',
                    style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                  ),
                ]),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                   child: CustomDivider(),
                ),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(getTranslated('total_amount', context), style: rubikMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor,
                  )),
                  Text(
                    PriceConverter.convertPrice(context, amount+_deliveryCharge),
                    style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
                  ),
                ]),
              ]),
              SizedBox(height: 30),

              CustomButton(btnTxt: getTranslated('ok', context), onTap: () {
                Navigator.pop(context);
              }),

            ]),
          ),
        );
      }),
    );
  }
}

import 'package:sparsh_user/provider/localization_provider.dart';
import 'package:sparsh_user/view/base/footer_web_view.dart';
import 'package:sparsh_user/view/base/product_shimmer.dart';
import 'package:sparsh_user/view/base/web_header/web_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:sparsh_user/helper/responsive_helper.dart';
import 'package:sparsh_user/localization/language_constrants.dart';
import 'package:sparsh_user/provider/auth_provider.dart';
import 'package:sparsh_user/provider/wishlist_provider.dart';
import 'package:sparsh_user/utill/dimensions.dart';
import 'package:sparsh_user/view/base/custom_app_bar.dart';
import 'package:sparsh_user/view/base/no_data_screen.dart';
import 'package:sparsh_user/view/base/not_logged_in_screen.dart';
import 'package:sparsh_user/view/base/product_widget.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return Scaffold(
      appBar:ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)) : CustomAppBar(title: getTranslated('my_favourite', context), isBackButtonExist: !ResponsiveHelper.isMobile(context)),
      body: _isLoggedIn ? SingleChildScrollView(
        child: Column(
          children: [
            Consumer<WishListProvider>(
              builder: (context, wishlistProvider, child) {
                return wishlistProvider.isLoading  ?
                Center(
                  child: SizedBox(
                    width: Dimensions.WEB_SCREEN_WIDTH,
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                        mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                        childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : 4,
                        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 2 : 1,
                      ),
                      itemBuilder: (context, index) {
                        return ProductShimmer(isEnabled: wishlistProvider.wishIdList == null,isWeb:  ResponsiveHelper.isDesktop(context) ? true : false);
                      },
                    ),
                  ),
                ) : wishlistProvider.wishIdList.length > 0 ?
                RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<WishListProvider>(context, listen: false).initWishList(
                      context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                    );
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Container(
                          constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                          width: Dimensions.WEB_SCREEN_WIDTH,
                          child:
                          GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                                mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                                childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : 4,
                                crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 2 : 1),
                            itemCount: wishlistProvider.wishList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            itemBuilder: (context, index) {
                              return ProductWidget(product: wishlistProvider.wishList[index]);
                            },
                          ),
                      ),
                    ),
                  ),
                 )
                )
                 : NoDataScreen();
              },
            ),
            if(ResponsiveHelper.isDesktop(context)) FooterView(),
          ],
        ),
      ) : NotLoggedInScreen(),
    );
  }
}

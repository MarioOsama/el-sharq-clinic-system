import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/dashboard/data/models/list_tile_item_model.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/cases_last_week.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/low_stock_products.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/popular_items.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/today_sales_container.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/today_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionDetailsContainer(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TodayOverview(),
            ),
            verticalSpace(100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  SizedBox(
                      width: 500.w,
                      child: const AspectRatio(
                          aspectRatio: 2, child: CasesLastWeek())),
                  const Spacer(),
                  SizedBox(
                    width: 500.w,
                    child: const AspectRatio(
                        aspectRatio: 2, child: TodaySalesContainer()),
                  ),
                ],
              ),
            ),
            verticalSpace(50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  SizedBox(
                      width: 500.w,
                      child: const AspectRatio(
                          aspectRatio: 2,
                          child: LowStockProducts(
                            items: [
                              ListTileItemModel(
                                  productName: 'Product 1',
                                  productType: 'Product Type 1',
                                  price: 100,
                                  quantity: 5),
                              ListTileItemModel(
                                  productName: 'Product 2',
                                  productType: 'Product Type 2',
                                  price: 100,
                                  quantity: 2),
                              ListTileItemModel(
                                  productName: 'Product 3',
                                  productType: 'Product Type 3',
                                  price: 100,
                                  quantity: 3),
                              ListTileItemModel(
                                  productName: 'Product 4',
                                  productType: 'Product Type 4',
                                  price: 100,
                                  quantity: 5),
                              ListTileItemModel(
                                  productName: 'Product 5',
                                  productType: 'Product Type 5',
                                  price: 100,
                                  quantity: 4),
                            ],
                          ))),
                  const Spacer(),
                  SizedBox(
                    width: 500.w,
                    child: const AspectRatio(
                        aspectRatio: 2,
                        child: PopularItems(
                          items: [
                            ListTileItemModel(
                                productName: 'Product 1',
                                productType: 'Product Type 1',
                                price: 100,
                                quantity: 10),
                            ListTileItemModel(
                                productName: 'Product 2',
                                productType: 'Product Type 2',
                                price: 100,
                                quantity: 20),
                            ListTileItemModel(
                                productName: 'Product 3',
                                productType: 'Product Type 3',
                                price: 100,
                                quantity: 30),
                            ListTileItemModel(
                                productName: 'Product 4',
                                productType: 'Product Type 4',
                                price: 100,
                                quantity: 40),
                            ListTileItemModel(
                                productName: 'Product 5',
                                productType: 'Product Type 5',
                                price: 100,
                                quantity: 50),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            verticalSpace(25),
          ],
        ),
      ),
    );
  }
}

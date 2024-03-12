import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/features/product/presentation/bloc/product/product_bloc.dart';

class UnitCard extends StatelessWidget {
  const UnitCard(this.index, this.discount, this.unitId,this.unitName,this.unitDesc,this.price,this.state,{super.key});
  final int index;final int discount;final int unitId;final String unitName;final String unitDesc;final int price;final ProductState state;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        context.read<ProductBloc>()..add(ChangeUnitIndex(index));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.01),
        decoration: BoxDecoration(
            color: state.unitIndex == index ? Color(0xFFFEF1F3) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: state.unitIndex == index ? Border.all(
                color: theme.primary,
                width: 2.5
            ) : Border()
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.shopping_cart,size: 20,color: theme.primary,),
            SizedBox(width: width*0.02,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      '${unitName}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                          color: theme.primary,letterSpacing: 1.5),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.005,
                  ),
                  Container(
                    child: Text(
                      '${unitDesc}',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: width*0.02,),
            discount != 0 ?  Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${price.toString()}\$',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${(price * (100 - discount)) / 100}\$',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ) : Text(
              '${price.toString()}\$',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

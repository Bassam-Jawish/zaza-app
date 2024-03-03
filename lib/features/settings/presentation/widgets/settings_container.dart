import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/app_export.dart';

class SettingsContainer extends StatelessWidget {
  const SettingsContainer(this.iconData, this.onPressed,this.title,{super.key});

  final IconData iconData;
  final VoidCallback onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: height * 0.25,
          width: width * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              width: 2,
              color: theme.primary,
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 3),
                color: Colors.redAccent.withOpacity(0.6),
                blurRadius: 5,
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Icon(
              iconData,
              size: 50,
              color: theme.primary,
            ),
            onPressed: onPressed,
          ),
        ),
        SizedBox(height: height*0.01,),
        Text('${title}',style: TextStyle(color: Colors.black,fontSize: 16.sp,fontWeight: FontWeight.w600),),

      ],
    );
  }
}

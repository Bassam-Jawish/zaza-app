import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/injection_container.dart';

import '../../../../core/app_export.dart';

class PhoneNumberCard extends StatelessWidget {
  PhoneNumberCard(
      this.index, this.number, this.number_code, this.phoneId, this.userId,
      {super.key});

  final int index;
  final String number_code;
  final String number;
  final int phoneId;
  int userId;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Mobile:',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            Text(
              '${number_code}',
              style: TextStyle(
                  color: AppColor.primaryLight,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            Text(
              '${number}',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            context
                .read<ProfileBloc>()
                .add(DeletePhone(languageCode, phoneId, index));
          },
          icon: Icon(Icons.delete),
          color: Colors.red,
          iconSize: 20,
        ),
      ],
    );
  }
}

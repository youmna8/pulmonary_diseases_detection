import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
ThemeData getAppTheme() {
  return ThemeData(
      //scaffoldBackgroundColor: AppColors.background,
      appBarTheme:
          AppBarTheme(backgroundColor: Colors.black, centerTitle: true),
      textTheme: TextTheme(
          displayLarge: GoogleFonts.lato(
              color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold),
          displayMedium: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 19.sp,
          ),
          displaySmall: GoogleFonts.lato(
              color:Colors.white.withOpacity(0.44), fontSize: 16.sp)),
      elevatedButtonTheme: ElevatedButtonThemeData(
      
          style: ElevatedButton.styleFrom(
            
              backgroundColor: Color(0xff447055),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  ),
                 
                  ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    
                    hintStyle: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 16.sp,
          ),
                    //fillColor: AppColors.textfield,
                    filled: true,
                  )
                  );
}
import 'package:flutter/material.dart';

class AppText {
  static const String _font = "SFProDisplay";

  // --------------------------
  // REGULAR (400)
  // --------------------------
  static const regular14 = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const regular16 = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const regular18 = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  // --------------------------
  // MEDIUM (500)
  // --------------------------
  static const medium14 = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const medium16 = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const medium18 = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  // --------------------------
  // BOLD (700)
  // --------------------------
  static const bold16 = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const bold20 = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  // --------------------------
  // SEMI-BOLD ITALIC (600 + italic)
  // --------------------------
  static const semiBoldItalic14 = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
  );

  static const semiBoldItalic16 = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
  );

  // --------------------------
  // THIN ITALIC (200)
  // --------------------------
  static const thinItalic14 = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w200,
    fontStyle: FontStyle.italic,
  );

  // --------------------------
  // ULTRA LIGHT ITALIC (100)
  // --------------------------
  static const ultraLightItalic14 = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w100,
    fontStyle: FontStyle.italic,
  );
}

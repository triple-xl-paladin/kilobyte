/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file app_text_widgets.dart is part of kilobyte
 *
 * kilobyte is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * kilobyte is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with kilobyte.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';

class AppTextWidgets {
  static Widget header(String text, {TextAlign? align}) => Text(
    text,
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    textAlign: align,
  );

  static Widget subHeader(String text, {TextAlign? align}) => Text(
    text,
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    textAlign: align,
  );

  static Widget body(String text, {TextAlign? align}) =>
      Text(text, style: TextStyle(fontSize: 15), textAlign: align);

  static Widget check(String text, {TextAlign? align}) =>
      Text(text, style: TextStyle(fontSize: 14, fontFamily: 'monospace'), textAlign: align);

  static Widget note(String text, {TextAlign? align}) =>
      Text(text, style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic), textAlign: align);
}

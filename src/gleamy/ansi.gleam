//// 
//// - **Text style**
////   - [`bold`](#bold)
////   - [`italic`](#italic)
////   - [`underline`](#underline)
////   - [`strikethrough`](#strikethrough)
////   - [`inverse`](#inverse)
////   - [`dim`](#dim)
////   - [`hidden`](#hidden)
////   - [`reset`](#reset)
//// - **Text colour**
////   - [`black`](#black)
////   - [`red`](#red)
////   - [`green`](#green)
////   - [`yellow`](#yellow)
////   - [`blue`](#blue)
////   - [`magenta`](#magenta)
////   - [`cyan`](#cyan)
////   - [`white`](#white)
////   - [`pink`](#pink)
////   - [`grey`](#grey)
////   - [`gray`](#gray)
////   - [`bright_black`](#bright_black)
////   - [`bright_red`](#bright_red)
////   - [`bright_green`](#bright_green)
////   - [`bright_yellow`](#bright_yellow)
////   - [`bright_blue`](#bright_blue)
////   - [`bright_magenta`](#bright_magenta)
////   - [`bright_cyan`](#bright_cyan)
////   - [`bright_white`](#bright_white)
////   - [`rgb8`](#rgb8)
////   - [`rgb24`](#rgb24)
//// - **Background colour**
////   - [`bg_black`](#bg_black)
////   - [`bg_red`](#bg_red)
////   - [`bg_green`](#bg_green)
////   - [`bg_yellow`](#bg_yellow)
////   - [`bg_blue`](#bg_blue)
////   - [`bg_magenta`](#bg_magenta)
////   - [`bg_cyan`](#bg_cyan)
////   - [`bg_white`](#bg_white)
////   - [`bg_pink`](#bg_pink)
////   - [`bg_bright_black`](#bg_bright_black)
////   - [`bg_bright_red`](#bg_bright_red)
////   - [`bg_bright_green`](#bg_bright_green)
////   - [`bg_bright_yellow`](#bg_bright_yellow)
////   - [`bg_bright_blue`](#bg_bright_blue)
////   - [`bg_bright_magenta`](#bg_bright_magenta)
////   - [`bg_bright_cyan`](#bg_bright_cyan)
////   - [`bg_bright_white`](#bg_bright_white)
////   - [`bg_rgb8`](#bg_rgb8)
////   - [`bg_rgb24`](#bg_rgb24)
//// 
//// ---
////
//// This package was heavily inspired by the `colours` module in the Deno standard
//// library. The original source code can be found
//// <a href="https://deno.land/std@0.167.0/fmt/colours.ts">here</a>.
////
//// <details>
//// <summary>The license of that package is produced below:</summary>
//// 
//// 
//// > MIT License
////
//// > Copyright 2018-2022 the Deno authors.
////
//// > Permission is hereby granted, free of charge, to any person obtaining a copy
//// of this software and associated documentation files (the "Software"), to deal
//// in the Software without restriction, including without limitation the rights
//// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//// copies of the Software, and to permit persons to whom the Software is
//// furnished to do so, subject to the following conditions:
////
//// > The above copyright notice and this permission notice shall be included in all
//// copies or substantial portions of the Software.
//// </details>
////

// Just in case we decide in the future to no longer include the above reference
// and license, this package was initially a port of the Deno `colours` module:
//
// https://deno.land/std@0.167.0/fmt/colours.ts
//

// This seems like a really handy reference if/when we want to expand this beyond
// formatting escape sequences:
//
// https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
//

// IMPORTS --------------------------------------------------------------------

import gleam/bitwise
import gleam/int
import gleam/list
import gleam/string

// CONSTS ---------------------------------------------------------------------

const asci_escape_character = ""

// TYPES ----------------------------------------------------------------------

type Code {
  Code(open: String, close: String, regexp: String)
}

// UTILITY --------------------------------------------------------------------

/// Builds colour code
fn code(open: List(Int), close: Int) -> Code {
  let close_str = int.to_string(close)
  let open_strs = list.map(open, int.to_string)

  Code(
    open: asci_escape_character <> "[" <> string.join(open_strs, ";") <> "m",
    close: asci_escape_character <> "[" <> close_str <> "m",
    regexp: asci_escape_character <> "[" <> close_str <> "m",
  )
}

/// Applies colour and background based on colour code and its associated text
fn run(text: String, code: Code) -> String {
  code.open <> string.replace(text, code.regexp, code.open) <> code.close
}

// STYLES ---------------------------------------------------------------------

/// Reset the text modified
pub fn reset(text: String) -> String {
  run(text, code([0], 0))
}

/// Make the text bold.
pub fn bold(text: String) -> String {
  run(text, code([1], 22))
}

/// The text emits only a small amount of light.
pub fn dim(text: String) -> String {
  run(text, code([2], 22))
}

/// Make the text italic.
pub fn italic(text: String) -> String {
  run(text, code([3], 23))
}

/// Make the text underline.
pub fn underline(text: String) -> String {
  run(text, code([4], 24))
}

///  Invert background colour and text colour.
pub fn inverse(text: String) -> String {
  run(text, code([7], 27))
}

/// Make the text hidden.
pub fn hidden(text: String) -> String {
  run(text, code([8], 28))
}

/// Put horizontal line through the center of the text.
pub fn strikethrough(text: String) -> String {
  run(text, code([9], 29))
}

// FOREGROUND -----------------------------------------------------------------

/// Colour the given text black. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.black("lucy")
///   // => "\e[30mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn black(text: String) -> String {
  run(text, code([30], 39))
}

/// Colour the given text red. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.red("lucy")
///   // => "\e[31mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleam/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn red(text: String) -> String {
  run(text, code([31], 39))
}

/// Colour the given text green. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.green("lucy")
///   // => "\e[32mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn green(text: String) -> String {
  run(text, code([32], 39))
}

/// Colour the given text yellow. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("lucy")
///   // => "\e[33mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn yellow(text: String) -> String {
  run(text, code([33], 39))
}

/// Colour the given text blue. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.blue("lucy")
///   // => "\e[34mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn blue(text: String) -> String {
  run(text, code([34], 39))
}

/// Colour the given text magenta. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.magenta("lucy")
///   // => "\e[35mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn magenta(text: String) -> String {
  run(text, code([35], 39))
}

/// Colour the given text cyan. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.cyan("lucy")
///   // => "\e[36mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn cyan(text: String) -> String {
  run(text, code([36], 39))
}

/// Colour the given text white. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.white("lucy")
///   // => "\e[37mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn white(text: String) -> String {
  run(text, code([37], 39))
}

/// Colour the given text gray. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.gray("lucy")
///   // => "\e[90mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn grey(text: String) -> String {
  bright_black(text)
}

/// This is an alias for [`grey`](#grey) for those who prefer the American English
/// spelling.
///
pub fn gray(text: String) -> String {
  bright_black(text)
}

/// Colour the given text bright black. This should increase the luminosity of
/// the base colour, but some terminals will interpret this as bold instead.
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bright_black("lucy")
///   // => "\e[90mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bright_black(text: String) -> String {
  run(text, code([90], 39))
}

/// Colour the given text bright red. This should increase the luminosity of
/// the base colour, but some terminals will interpret this as bold instead.
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bright_red("lucy")
///   // => "\e[91mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bright_red(text: String) -> String {
  run(text, code([91], 39))
}

/// Colour the given text bright green. This should increase the luminosity of
/// the base colour, but some terminals will interpret this as bold instead.
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// fn example() {
///   ansi.bright_green("lucy")
///   // => "\e[92mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bright_green(text: String) -> String {
  run(text, code([92], 39))
}

/// Colour the given text bright yellow. This should increase the luminosity of
/// the base colour, but some terminals will interpret this as bold instead.
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// fn example() {
///   ansi.bright_yellow("lucy")
///   // => "\e[93mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bright_yellow(text: String) -> String {
  run(text, code([93], 39))
}

/// Colour the given text bright blue. This should increase the luminosity of
/// the base colour, but some terminals will interpret this as bold instead.
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// fn example() {
///   ansi.bright_blue("lucy")
///   // => "\e[94mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bright_blue(text: String) -> String {
  run(text, code([94], 39))
}

/// Colour the given text bright gremagentaen. This should increase the luminosity
/// of the base colour, but some terminals will interpret this as bold instead.
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// fn example() {
///   ansi.bright_magenta("lucy")
///   // => "\e[95mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bright_magenta(text: String) -> String {
  run(text, code([95], 39))
}

/// Colour the given text bright cyan. This should increase the luminosity of
/// the base colour, but some terminals will interpret this as bold instead.
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// fn example() {
///   ansi.bright_cyan("lucy")
///   // => "\e[96mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bright_cyan(text: String) -> String {
  run(text, code([96], 39))
}

/// Colour the given text bright white. This should increase the luminosity of
/// the base colour, but some terminals will interpret this as bold instead.
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// fn example() {
///   ansi.bright_white("lucy")
///   // => "\e[97mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bright_white(text: String) -> String {
  run(text, code([97], 39))
}

/// Colour the given text pink. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.pink("lucy")
///   // => "\e[38;2;255;175;243mlucy\e[39m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[39m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn pink(text: String) -> String {
  rgb24(text, 0xffaff3)
}

/// Set text colour using paletted 8bit colours.
///
/// ## Example
///
/// ```gleam
/// let white_text = rgb8("lucy", 255)
/// ```
pub fn rgb8(text: String, colour: Int) -> String {
  run(text, code([38, 5, int.clamp(colour, max: 255, min: 0)], 39))
}

/// Set text colour using 24bit rgb.
///
/// ## Example
///
/// ```gleam
/// let blue_text = rgb24("lucy", 0xa6fffb)
/// ```
pub fn rgb24(text: String, colour: Int) -> String {
  let colour = int.clamp(colour, max: 0xffffff, min: 0x0)
  run(
    text,
    code(
      [
        38,
        2,
        bitwise.shift_right(colour, 16)
        |> bitwise.and(0xff),
        bitwise.shift_right(colour, 8)
        |> bitwise.and(0xff),
        bitwise.and(colour, 0xff),
      ],
      39,
    ),
  )
}

// BACKGROUND -----------------------------------------------------------------

/// Colour the given text's background black. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_black("lucy")
///   // => "\e[40mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_black(text: String) -> String {
  run(text, code([40], 49))
}

/// Colour the given text's background red. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_red("lucy")
///   // => "\e[41mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_red(text: String) -> String {
  run(text, code([41], 49))
}

/// Colour the given text's background green. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_green("lucy")
///   // => "\e[42mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_green(text: String) -> String {
  run(text, code([42], 49))
}

/// Colour the given text's background yellow. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_yellow("lucy")
///   // => "\e[43mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_yellow(text: String) -> String {
  run(text, code([43], 49))
}

/// Colour the given text's background blue. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_blue("lucy")
///   // => "\e[44mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_blue(text: String) -> String {
  run(text, code([44], 49))
}

/// Colour the given text's background magenta. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_magenta("lucy")
///   // => "\e[45mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_magenta(text: String) -> String {
  run(text, code([45], 49))
}

/// Colour the given text's background cyan. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_cyan("lucy")
///   // => "\e[46mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_cyan(text: String) -> String {
  run(text, code([46], 49))
}

/// Colour the given text's background white. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_white("lucy")
///   // => "\e[47mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_white(text: String) -> String {
  run(text, code([47], 49))
}

/// Colour the given text's background bright black. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_bright_black("lucy")
///   // => "\e[100mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_bright_black(text: String) -> String {
  run(text, code([100], 49))
}

/// Colour the given text's background bright red. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_bright_red("lucy")
///   // => "\e[101mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_bright_red(text: String) -> String {
  run(text, code([101], 49))
}

/// Colour the given text's background bright green. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_bright_green("lucy")
///   // => "\e[102mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_bright_green(text: String) -> String {
  run(text, code([102], 49))
}

/// Colour the given text's background bright yellow. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_bright_yellow("lucy")
///   // => "\e[103mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_bright_yellow(text: String) -> String {
  run(text, code([103], 49))
}

/// Colour the given text's background bright blue. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_bright_blue("lucy")
///   // => "\e[104mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_bright_blue(text: String) -> String {
  run(text, code([104], 49))
}

/// Colour the given text's background bright magenta. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_bright_magenta("lucy")
///   // => "\e[105mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_bright_magenta(text: String) -> String {
  run(text, code([105], 49))
}

/// Colour the given text's background bright cyan. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_bright_cyan("lucy")
///   // => "\e[106mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_bright_cyan(text: String) -> String {
  run(text, code([106], 49))
}

/// Colour the given text's background bright white. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_bright_white("lucy")
///   // => "\e[107mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_bright_white(text: String) -> String {
  run(text, code([107], 49))
}

/// Colour the given text's background pink. 
///
/// <details>
/// <summary>Example:</summary>
///
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.bg_pink("lucy")
///   // => "\e[48;2;255;175;243mlucy\e[49m"
/// }
/// ```
///
/// ❗️ Note the trailing `"\e[49m"` added to the string. This is the escape code
/// for the "default" colour of the terminal. This means text you write after
/// this will revert back to default.
///
/// ✨ `gleamy/ansi` is smart about nested styles; instead of using the default
/// colour, it will use the colour of the outter style.
/// 
/// ```gleam
/// import gleamy/ansi
/// 
/// fn example() {
///   ansi.yellow("Isn't " <> ansi.pink("Gleam") <> " fun?")
/// }
/// ```
/// 
/// In this example, the text "Gleam" will be pink but the text "fun?" will be
/// yellow, *not* the default colour!
/// </details>
///
/// <div style="position: relative;">
///     <a style="position: absolute; left: 0;" href="https://github.com/gleam-community/ansi/issues">
///         <small>Spot a typo? Open an issue!</small>
///     </a>
///     <a style="position: absolute; right: 0;" href="#">
///         <small>Back to top ↑</small>
///     </a>
/// </div>
///
pub fn bg_pink(text: String) -> String {
  bg_rgb24(text, 0xffaff3)
}

/// Set background colour using paletted 8bit colours.
///
/// ## Example
///
/// ```gleam
/// let white_background = bg_rgb8("lucy", 255)
/// ```
pub fn bg_rgb8(text: String, colour: Int) -> String {
  run(text, code([48, 5, int.clamp(colour, max: 255, min: 0)], 49))
}

/// Set background colour using 24bit rgb.
///
/// ## Example
///
/// ```gleam
/// let blue_background = bg_rgb24("lucy", 0xa6fffb)
/// ```
pub fn bg_rgb24(text: String, colour: Int) -> String {
  run(
    text,
    code(
      [
        48,
        2,
        bitwise.shift_right(colour, 16)
        |> bitwise.and(0xff),
        bitwise.shift_right(colour, 8)
        |> bitwise.and(0xff),
        bitwise.and(colour, 0xff),
      ],
      49,
    ),
  )
}

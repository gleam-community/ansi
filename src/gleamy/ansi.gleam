// Adapted for gleam from https://deno.land/std@0.167.0/fmt/colours.ts

// IMPORTS --------------------------------------------------------------------

import gleam/int
import gleam/string
import gleam/list
import gleam/bitwise

// CONSTS ---------------------------------------------------------------------

const asci_escape_character = ""

// TYPES ----------------------------------------------------------------------

type Code {
  Code(open: String, close: String, regexp: String)
}

// UTILITY --------------------------------------------------------------------

// /**
//  * Builds colour code
//  * @param open
//  * @param close
//  */
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

/// Set text colour to black.
pub fn black(text: String) -> String {
  run(text, code([30], 39))
}

/// Set text colour to red.
pub fn red(text: String) -> String {
  run(text, code([31], 39))
}

/// Set text colour to green.
pub fn green(text: String) -> String {
  run(text, code([32], 39))
}

/// Set text colour to yellow.
pub fn yellow(text: String) -> String {
  run(text, code([33], 39))
}

/// Set text colour to blue.
pub fn blue(text: String) -> String {
  run(text, code([34], 39))
}

/// Set text colour to magenta.
pub fn magenta(text: String) -> String {
  run(text, code([35], 39))
}

/// Set text colour to cyan.
pub fn cyan(text: String) -> String {
  run(text, code([36], 39))
}

/// Set text colour to white.
pub fn white(text: String) -> String {
  run(text, code([37], 39))
}

/// Set text colour to gray.
pub fn gray(text: String) -> String {
  bright_black(text)
}

/// Set text colour to bright black.
pub fn bright_black(text: String) -> String {
  run(text, code([90], 39))
}

/// Set text colour to bright red.
pub fn bright_red(text: String) -> String {
  run(text, code([91], 39))
}

/// Set text colour to bright green.
pub fn bright_green(text: String) -> String {
  run(text, code([92], 39))
}

/// Set text colour to bright yellow.
pub fn bright_yellow(text: String) -> String {
  run(text, code([93], 39))
}

/// Set text colour to bright blue.
pub fn bright_blue(text: String) -> String {
  run(text, code([94], 39))
}

/// Set text colour to bright magenta.
pub fn bright_magenta(text: String) -> String {
  run(text, code([95], 39))
}

/// Set text colour to bright cyan.
pub fn bright_cyan(text: String) -> String {
  run(text, code([96], 39))
}

/// Set text colour to bright white.
pub fn bright_white(text: String) -> String {
  run(text, code([97], 39))
}

/// Set text colour to #ffaff3
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

/// Set background colour to black.
pub fn bg_black(text: String) -> String {
  run(text, code([40], 49))
}

/// Set background colour to red.
pub fn bg_red(text: String) -> String {
  run(text, code([41], 49))
}

/// Set background colour to green.
pub fn bg_green(text: String) -> String {
  run(text, code([42], 49))
}

/// Set background colour to yellow.
pub fn bg_yellow(text: String) -> String {
  run(text, code([43], 49))
}

/// Set background colour to blue.
pub fn bg_blue(text: String) -> String {
  run(text, code([44], 49))
}

/// Set background colour to magenta.
pub fn bg_magenta(text: String) -> String {
  run(text, code([45], 49))
}

/// Set background colour to cyan.
pub fn bg_cyan(text: String) -> String {
  run(text, code([46], 49))
}

/// Set background colour to white.
pub fn bg_white(text: String) -> String {
  run(text, code([47], 49))
}

/// Set background colour to bright black.
pub fn bg_bright_black(text: String) -> String {
  run(text, code([100], 49))
}

/// Set background colour to bright red.
pub fn bg_bright_red(text: String) -> String {
  run(text, code([101], 49))
}

/// Set background colour to bright green.
pub fn bg_bright_green(text: String) -> String {
  run(text, code([102], 49))
}

/// Set background colour to bright yellow.
pub fn bg_bright_yellow(text: String) -> String {
  run(text, code([103], 49))
}

/// Set background colour to bright blue.
pub fn bg_bright_blue(text: String) -> String {
  run(text, code([104], 49))
}

/// Set background colour to bright magenta.
pub fn bg_bright_magenta(text: String) -> String {
  run(text, code([105], 49))
}

/// Set background colour to bright cyan.
pub fn bg_bright_cyan(text: String) -> String {
  run(text, code([106], 49))
}

/// Set background colour to bright white.
pub fn bg_bright_white(text: String) -> String {
  run(text, code([107], 49))
}

/// Set background to #ffaff3
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

import gleeunit
import gleeunit/should
import gleamy/ansi

pub fn main() {
  gleeunit.main()
}

pub fn reset_test() {
  ansi.reset("foo bar")
  |> should.equal("[0mfoo bar[0m")
}

pub fn single_color_test() {
  ansi.red("foo bar")
  |> should.equal("[31mfoo bar[39m")
}

pub fn double_color_test() {
  "foo bar"
  |> ansi.red()
  |> ansi.bg_blue()
  |> should.equal("[44m[31mfoo bar[39m[49m")
}

pub fn replaces_close_characters_test() {
  "Hel[39mlo"
  |> ansi.red()
  |> should.equal("[31mHel[31mlo[39m")
}

pub fn bold_test() {
  "foo bar"
  |> ansi.bold()
  |> should.equal("[1mfoo bar[22m")
}

pub fn dim_test() {
  "foo bar"
  |> ansi.dim()
  |> should.equal("[2mfoo bar[22m")
}

pub fn italic_test() {
  "foo bar"
  |> ansi.italic()
  |> should.equal("[3mfoo bar[23m")
}

pub fn underline_test() {
  "foo bar"
  |> ansi.underline()
  |> should.equal("[4mfoo bar[24m")
}

pub fn inverse_test() {
  "foo bar"
  |> ansi.inverse()
  |> should.equal("[7mfoo bar[27m")
}

pub fn hidden_test() {
  "foo bar"
  |> ansi.hidden()
  |> should.equal("[8mfoo bar[28m")
}

pub fn strikethrough_test() {
  "foo bar"
  |> ansi.strikethrough()
  |> should.equal("[9mfoo bar[29m")
}

pub fn black_test() {
  "foo bar"
  |> ansi.black()
  |> should.equal("[30mfoo bar[39m")
}

pub fn red_test() {
  "foo bar"
  |> ansi.red()
  |> should.equal("[31mfoo bar[39m")
}

pub fn green_test() {
  "foo bar"
  |> ansi.green()
  |> should.equal("[32mfoo bar[39m")
}

pub fn yellow_test() {
  "foo bar"
  |> ansi.yellow()
  |> should.equal("[33mfoo bar[39m")
}

pub fn blue_test() {
  "foo bar"
  |> ansi.blue()
  |> should.equal("[34mfoo bar[39m")
}

pub fn magenta_test() {
  "foo bar"
  |> ansi.magenta()
  |> should.equal("[35mfoo bar[39m")
}

pub fn cyan_test() {
  "foo bar"
  |> ansi.cyan()
  |> should.equal("[36mfoo bar[39m")
}

pub fn white_test() {
  "foo bar"
  |> ansi.white()
  |> should.equal("[37mfoo bar[39m")
}

pub fn gray_test() {
  "foo bar"
  |> ansi.gray()
  |> should.equal("[90mfoo bar[39m")
}

pub fn bright_black_test() {
  "foo bar"
  |> ansi.bright_black()
  |> should.equal("[90mfoo bar[39m")
}

pub fn bright_red_test() {
  "foo bar"
  |> ansi.bright_red()
  |> should.equal("[91mfoo bar[39m")
}

pub fn bright_green_test() {
  "foo bar"
  |> ansi.bright_green()
  |> should.equal("[92mfoo bar[39m")
}

pub fn bright_yellow_test() {
  "foo bar"
  |> ansi.bright_yellow()
  |> should.equal("[93mfoo bar[39m")
}

pub fn bright_blue_test() {
  "foo bar"
  |> ansi.bright_blue()
  |> should.equal("[94mfoo bar[39m")
}

pub fn bright_magenta_test() {
  "foo bar"
  |> ansi.bright_magenta()
  |> should.equal("[95mfoo bar[39m")
}

pub fn bright_cyan_test() {
  "foo bar"
  |> ansi.bright_cyan()
  |> should.equal("[96mfoo bar[39m")
}

pub fn bright_white_test() {
  "foo bar"
  |> ansi.bright_white()
  |> should.equal("[97mfoo bar[39m")
}

pub fn bg_black_test() {
  "foo bar"
  |> ansi.bg_black()
  |> should.equal("[40mfoo bar[49m")
}

pub fn bg_red_test() {
  "foo bar"
  |> ansi.bg_red()
  |> should.equal("[41mfoo bar[49m")
}

pub fn bg_green_test() {
  "foo bar"
  |> ansi.bg_green()
  |> should.equal("[42mfoo bar[49m")
}

pub fn bg_yellow_test() {
  "foo bar"
  |> ansi.bg_yellow()
  |> should.equal("[43mfoo bar[49m")
}

pub fn bg_blue_test() {
  "foo bar"
  |> ansi.bg_blue()
  |> should.equal("[44mfoo bar[49m")
}

pub fn bg_magenta_test() {
  "foo bar"
  |> ansi.bg_magenta()
  |> should.equal("[45mfoo bar[49m")
}

pub fn bg_cyan_test() {
  "foo bar"
  |> ansi.bg_cyan()
  |> should.equal("[46mfoo bar[49m")
}

pub fn bg_white_test() {
  "foo bar"
  |> ansi.bg_white()
  |> should.equal("[47mfoo bar[49m")
}

pub fn bg_bright_black_test() {
  "foo bar"
  |> ansi.bg_bright_black()
  |> should.equal("[100mfoo bar[49m")
}

pub fn bg_bright_red_test() {
  "foo bar"
  |> ansi.bg_bright_red()
  |> should.equal("[101mfoo bar[49m")
}

pub fn bg_bright_green_test() {
  "foo bar"
  |> ansi.bg_bright_green()
  |> should.equal("[102mfoo bar[49m")
}

pub fn bg_bright_yellow_test() {
  "foo bar"
  |> ansi.bg_bright_yellow()
  |> should.equal("[103mfoo bar[49m")
}

pub fn bg_bright_blue_test() {
  "foo bar"
  |> ansi.bg_bright_blue()
  |> should.equal("[104mfoo bar[49m")
}

pub fn bg_bright_magenta_test() {
  "foo bar"
  |> ansi.bg_bright_magenta()
  |> should.equal("[105mfoo bar[49m")
}

pub fn bg_bright_cyan_test() {
  "foo bar"
  |> ansi.bg_bright_cyan()
  |> should.equal("[106mfoo bar[49m")
}

pub fn bg_bright_white_test() {
  "foo bar"
  |> ansi.bg_bright_white()
  |> should.equal("[107mfoo bar[49m")
}

pub fn clamp_using_rgb8_test() {
  "foo bar"
  |> ansi.rgb8(-10)
  |> should.equal("[38;5;0mfoo bar[39m")
}

pub fn rgb8_test() {
  "foo bar"
  |> ansi.rgb8(42)
  |> should.equal("[38;5;42mfoo bar[39m")
}

pub fn bg_rbg8_test() {
  "foo bar"
  |> ansi.bg_rgb8(42)
  |> should.equal("[48;5;42mfoo bar[49m")
}

pub fn rbg24_test() {
  "foo bar"
  |> ansi.rgb24(0x292A2B)
  |> should.equal("[38;2;41;42;43mfoo bar[39m")
}

pub fn bg_rbg24_test() {
  "foo bar"
  |> ansi.bg_rgb24(0x292A2B)
  |> should.equal("[48;2;41;42;43mfoo bar[49m")
}

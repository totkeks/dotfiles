# https://ethanschoonover.com/solarized/#the-values
#
# Regular text is base0 on base03
# Highlighted text is base1 on base02
#
# Solarized Hex     PSStyle       Dark theme
# --------- ------- ------------- ------------------------
# base03    #002B36 BrightBlack   background
# base02    #073642 Black         background highlights
# base01    #586E75 BrightGreen   comments / secondary content
# base00    #657B83 BrightYellow  unused
# base0     #839496 BrightBlue    body text / default code / primary content
# base1     #93A1A1 BrightCyan    optional emphasized content
# base2     #EEE8D5 White         unused
# base3     #FDF6E3 BrightWhite   unused
# yellow    #B58900 Yellow        Split Complement
# orange    #CB4B16 BrightRed     Complement
# red       #DC322F Red           Triad
# magenta   #D33682 Magenta       Tetrad
# violet    #6C71C4 BrightMagenta Analogous
# blue      #268BD2 Blue          Monotone
# cyan      #2AA198 Cyan          Analogous
# green     #859900 Green         Tetrad

Set-PSReadLineOption -Colors @{
	"Command"            = $PSStyle.Foreground.Blue
	"Comment"            = $PSStyle.Foreground.BrightGreen
	"ContinuationPrompt" = $PSStyle.Foreground.BrightGreen
	"Default"            = $PSStyle.Foreground.BrightBlue
	"Emphasis"           = $PSStyle.Background.Black + $PSStyle.Foreground.BrightCyan
	"Error"              = $PSStyle.Foreground.Red
	"InlinePrediction"   = $PSStyle.Foreground.BrightGreen
	"Keyword"            = $PSStyle.Foreground.Green
	# "ListPrediction"         = $PSStyle.Foreground.BrightBlue
	# "ListPredictionSelected" = $PSStyle.Background.Black + $PSStyle.Foreground.BrightCyan
	"Member"             = $PSStyle.Foreground.BrightCyan
	"Number"             = $PSStyle.Foreground.BrightCyan
	"Operator"           = $PSStyle.Foreground.BrightGreen
	"Parameter"          = $PSStyle.Foreground.BrightGreen
	"Selection"          = $PSStyle.Background.Black + $PSStyle.Foreground.BrightCyan
	"String"             = $PSSTyle.Foreground.Cyan
	"Type"               = $PSStyle.Bold + $PSStyle.Foreground.BrightCyan
	"Variable"           = $PSStyle.Foreground.Blue
}

# $PSStyle.Formatting.Debug
# $PSStyle.Formatting.Error
# $PSStyle.Formatting.ErrorAccent
# $PSStyle.Formatting.Warning
# $PSStyle.Formatting.Verbose
# $PSStyle.Formatting.TableHeader
# $PSStyle.Formatting.FormatAccent (Format-List)

# $PSStyle.FileInfo.Directory
# $PSStyle.FileInfo.Executable
# $PSStyle.FileInfo.SymbolicLink
# $PSStyle.FileInfo.Extension (array of file extensions)

# $PSStyle.Progress.Style

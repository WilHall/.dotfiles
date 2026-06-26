#!/usr/bin/env python3
"""Generate a VSCode color theme from the RubyMine "Catppuccin Frappe PrideCat"
.icls editor scheme.

Run with the system Python to avoid the asdf shim:

    /usr/bin/python3 generate-theme.py

It reads the exported scheme from ../rubymine/colors/ and writes the theme JSON
into theme-extension/themes/. Re-run whenever you tweak the scheme in RubyMine
and re-export it. Token colors and font styles are pulled live from the .icls so
your edits propagate; only the workbench (chrome) palette is authored here, built
on the Catppuccin Frappe palette the scheme is based on.
"""
import json
import os
import xml.etree.ElementTree as ET

HERE = os.path.dirname(os.path.abspath(__file__))
ICLS = os.path.join(
    HERE, "..", "rubymine", "colors", "Catppuccin Frappe PrideCat.icls"
)
OUT = os.path.join(
    HERE, "theme-extension", "themes",
    "catppuccin-frappe-pridecat-color-theme.json",
)

# Catppuccin Frappe palette — the scheme is built on this.
P = {
    "rosewater": "#f2d5cf", "flamingo": "#eebebe", "pink": "#f4b8e4",
    "mauve": "#ca9ee6", "red": "#e78284", "maroon": "#ea999c",
    "peach": "#ef9f76", "yellow": "#e5c890", "green": "#a6d189",
    "teal": "#81c8be", "sky": "#99d1db", "sapphire": "#85c1dc",
    "blue": "#8caaee", "lavender": "#babbf1", "text": "#c6d0f5",
    "subtext1": "#b5bfe2", "subtext0": "#a5adce", "overlay2": "#949cbb",
    "overlay1": "#838ba7", "overlay0": "#737994", "surface2": "#626880",
    "surface1": "#51576d", "surface0": "#414559", "base": "#303446",
    "mantle": "#292c3c", "crust": "#232634",
}


def parse_icls(path):
    """Return (named_colors, attributes) from the .icls."""
    root = ET.parse(path).getroot()
    named = {}
    colors_el = root.find("colors")
    if colors_el is not None:
        for opt in colors_el.findall("option"):
            named[opt.get("name")] = opt.get("value")

    attrs = {}
    attrs_el = root.find("attributes")
    if attrs_el is not None:
        for opt in attrs_el.findall("option"):
            name = opt.get("name")
            entry = {}
            for v in opt.findall("value"):
                for o in v.findall("option"):
                    entry[o.get("name")] = o.get("value")
            attrs[name] = entry
    return named, attrs


def hexc(v):
    """Normalize an .icls color (RRGGBB, possibly short) to #rrggbb."""
    if not v:
        return None
    v = v.strip().lstrip("#")
    if not v:
        return None
    v = v.zfill(6)
    return "#" + v.lower()


def named_color(named, key, fallback):
    return hexc(named.get(key)) or fallback


def font_style(entry):
    """Map JetBrains FONT_TYPE + EFFECT_TYPE to a VSCode fontStyle string."""
    styles = []
    ft = entry.get("FONT_TYPE")
    if ft in ("1", "3"):
        styles.append("bold")
    if ft in ("2", "3"):
        styles.append("italic")
    # EFFECT_TYPE: 1 = underline, 3 = strikethrough (e.g. deprecated)
    et = entry.get("EFFECT_TYPE")
    if et == "1":
        styles.append("underline")
    elif et == "3":
        styles.append("strikethrough")
    return " ".join(styles)


# JetBrains attribute -> TextMate scopes. Foreground + fontStyle are read live
# from the .icls; this table only decides which scopes each attribute paints.
TOKEN_MAP = [
    ("DEFAULT_KEYWORD", [
        "keyword", "keyword.control", "storage", "storage.type",
        "storage.modifier", "keyword.other"]),
    ("DEFAULT_OPERATION_SIGN", ["keyword.operator", "punctuation.operator"]),
    ("DEFAULT_STRING", [
        "string", "string.quoted", "string.template",
        "punctuation.definition.string"]),
    ("DEFAULT_VALID_STRING_ESCAPE", ["constant.character.escape"]),
    ("DEFAULT_INVALID_STRING_ESCAPE", ["invalid.illegal"]),
    ("DEFAULT_NUMBER", ["constant.numeric", "constant.language.boolean"]),
    ("DEFAULT_CONSTANT", [
        "constant.language", "constant.other", "variable.other.constant",
        "support.constant", "entity.name.constant"]),
    ("DEFAULT_LINE_COMMENT", [
        "comment", "comment.line", "punctuation.definition.comment"]),
    ("DEFAULT_BLOCK_COMMENT", ["comment.block"]),
    ("DEFAULT_DOC_COMMENT", ["comment.block.documentation"]),
    ("DEFAULT_DOC_COMMENT_TAG", [
        "keyword.other.documentation", "storage.type.class.jsdoc",
        "comment.block.documentation keyword"]),
    ("DEFAULT_DOC_COMMENT_TAG_VALUE", [
        "comment.block.documentation variable",
        "comment.block.documentation entity.name.type"]),
    ("DEFAULT_FUNCTION_DECLARATION", [
        "entity.name.function", "meta.function entity.name.function",
        "support.function"]),
    ("DEFAULT_FUNCTION_CALL", [
        "meta.function-call", "meta.function-call entity.name.function",
        "variable.function"]),
    ("DEFAULT_CLASS_NAME", [
        "entity.name.type", "entity.name.class", "entity.name.type.class"]),
    ("DEFAULT_CLASS_REFERENCE", ["support.class", "support.type"]),
    ("DEFAULT_INTERFACE_NAME", [
        "entity.name.type.interface", "entity.name.interface"]),
    ("DEFAULT_PARAMETER", [
        "variable.parameter", "variable.parameter.function"]),
    ("DEFAULT_LOCAL_VARIABLE", [
        "variable", "variable.other", "variable.other.readwrite"]),
    ("DEFAULT_INSTANCE_FIELD", [
        "variable.other.property", "variable.other.member",
        "variable.other.object.property", "support.variable.property"]),
    ("DEFAULT_STATIC_FIELD", [
        "variable.other.class", "variable.other.constant.property"]),
    ("DEFAULT_GLOBAL_VARIABLE", [
        "variable.other.global", "variable.language.global",
        "punctuation.definition.variable"]),
    ("DEFAULT_PREDEFINED_SYMBOL", [
        "variable.language", "support.type.builtin", "support.function.builtin"]),
    ("DEFAULT_METADATA", [
        "meta.decorator", "entity.name.function.decorator",
        "punctuation.decorator", "storage.type.annotation",
        "meta.annotation", "support.type.annotation"]),
    ("DEFAULT_LABEL", ["entity.name.label", "constant.other.label"]),
    ("DEFAULT_BRACES", ["punctuation.section", "meta.brace.curly"]),
    ("DEFAULT_BRACKETS", ["meta.brace.square", "punctuation.definition.array"]),
    ("DEFAULT_PARENTHS", ["meta.brace.round", "punctuation.definition.parameters"]),
    ("DEFAULT_COMMA", ["punctuation.separator", "punctuation.separator.comma"]),
    ("DEFAULT_DOT", ["punctuation.accessor", "punctuation.delimiter"]),
    ("DEFAULT_SEMICOLON", ["punctuation.terminator"]),
    # HTML
    ("HTML_TAG_NAME", [
        "entity.name.tag", "punctuation.definition.tag"]),
    ("HTML_ATTRIBUTE_NAME", [
        "entity.other.attribute-name", "entity.other.attribute-name.html"]),
    # CSS
    ("CSS.PROPERTY_NAME", [
        "support.type.property-name", "meta.property-name"]),
    ("CSS.PROPERTY_VALUE", [
        "support.constant.property-value", "meta.property-value"]),
    ("CSS.TAG_NAME", ["entity.name.tag.css"]),
    # Markdown
    ("MARKDOWN_HEADER_LEVEL_1", [
        "markup.heading", "markup.heading entity.name",
        "entity.name.section.markdown",
        "punctuation.definition.heading.markdown"]),
    ("MARKDOWN_BOLD", ["markup.bold"]),
    ("MARKDOWN_ITALIC", ["markup.italic"]),
    # diagnostics / misc
    ("DEPRECATED_ATTRIBUTES", ["invalid.deprecated"]),
    ("TODO_DEFAULT_ATTRIBUTES", ["comment keyword.todo"]),
]


def build_token_colors(attrs):
    out = []
    for jb_attr, scopes in TOKEN_MAP:
        entry = attrs.get(jb_attr)
        if not entry:
            continue
        settings = {}
        fg = hexc(entry.get("FOREGROUND"))
        if fg:
            settings["foreground"] = fg
        fs = font_style(entry)
        if fs:
            settings["fontStyle"] = fs
        if not settings:
            continue
        out.append({
            "name": jb_attr,
            "scope": scopes if len(scopes) > 1 else scopes[0],
            "settings": settings,
        })
    return out


def build_workbench(named, attrs):
    base = P["base"]
    text = P["text"]
    caret = named_color(named, "CARET_COLOR", P["rosewater"])
    line_hl = named_color(named, "CARET_ROW_COLOR", "#373b4e")
    selection = named_color(named, "SELECTION_BACKGROUND", "#4e5369")
    search = named_color(named, "SEARCH_RESULT_ATTRIBUTES", "#4c5778")
    indent = named_color(named, "INDENT_GUIDE", P["surface0"])
    indent_active = named_color(named, "SELECTED_INDENT_GUIDE", P["surface1"])
    line_no = named_color(named, "LINE_NUMBERS_COLOR", P["overlay0"])
    line_no_active = named_color(
        named, "LINE_NUMBER_ON_CARET_ROW_COLOR", P["overlay1"])
    whitespace = named_color(named, "WHITESPACES", P["overlay2"])
    ruler = named_color(named, "RIGHT_MARGIN_COLOR", P["surface0"])
    brace_match = hexc((attrs.get("MATCHED_BRACE_ATTRIBUTES") or {}).get(
        "EFFECT_COLOR")) or P["overlay0"]

    c = {
        # base
        "focusBorder": P["blue"] + "66",
        "foreground": text,
        "disabledForeground": P["overlay1"],
        "descriptionForeground": P["subtext0"],
        "errorForeground": P["red"],
        "selection.background": selection,
        "icon.foreground": P["blue"],
        "widget.shadow": P["crust"] + "66",
        # text colors
        "textLink.foreground": P["blue"],
        "textLink.activeForeground": P["lavender"],
        "textBlockQuote.background": P["mantle"],
        "textBlockQuote.border": P["blue"],
        "textCodeBlock.background": P["mantle"],
        "textPreformat.foreground": P["green"],
        "textSeparator.foreground": P["surface2"],
        # buttons
        "button.background": P["blue"],
        "button.foreground": P["crust"],
        "button.hoverBackground": P["sapphire"],
        "button.secondaryBackground": P["surface2"],
        "button.secondaryForeground": text,
        "button.secondaryHoverBackground": P["surface1"],
        "checkbox.background": P["surface0"],
        "checkbox.border": P["surface2"],
        "checkbox.foreground": P["blue"],
        # dropdowns
        "dropdown.background": P["mantle"],
        "dropdown.listBackground": P["surface0"],
        "dropdown.border": P["blue"],
        "dropdown.foreground": text,
        # input
        "input.background": P["mantle"],
        "input.border": P["surface2"],
        "input.foreground": text,
        "input.placeholderForeground": P["overlay1"],
        "inputOption.activeBackground": P["surface2"],
        "inputOption.activeBorder": P["blue"],
        "inputOption.activeForeground": text,
        "inputValidation.errorBackground": P["mantle"],
        "inputValidation.errorBorder": P["red"],
        "inputValidation.errorForeground": P["red"],
        "inputValidation.infoBackground": P["mantle"],
        "inputValidation.infoBorder": P["blue"],
        "inputValidation.warningBackground": P["mantle"],
        "inputValidation.warningBorder": P["yellow"],
        # scrollbar
        "scrollbar.shadow": P["crust"] + "00",
        "scrollbarSlider.background": P["surface1"] + "80",
        "scrollbarSlider.hoverBackground": P["surface2"] + "80",
        "scrollbarSlider.activeBackground": P["overlay0"] + "80",
        # badges
        "badge.background": P["blue"],
        "badge.foreground": P["crust"],
        "activityBarBadge.background": P["blue"],
        "activityBarBadge.foreground": P["crust"],
        # lists / trees
        "list.activeSelectionBackground": P["surface1"],
        "list.activeSelectionForeground": text,
        "list.inactiveSelectionBackground": P["surface0"],
        "list.inactiveSelectionForeground": text,
        "list.hoverBackground": P["surface0"] + "80",
        "list.hoverForeground": text,
        "list.focusBackground": P["surface1"],
        "list.focusForeground": text,
        "list.highlightForeground": P["blue"],
        "list.dropBackground": P["surface0"],
        "list.errorForeground": P["red"],
        "list.warningForeground": P["yellow"],
        "tree.indentGuidesStroke": indent,
        "listFilterWidget.background": P["mantle"],
        "listFilterWidget.outline": P["blue"],
        "listFilterWidget.noMatchesOutline": P["red"],
        # activity bar
        "activityBar.background": P["crust"],
        "activityBar.foreground": P["blue"],
        "activityBar.inactiveForeground": P["overlay0"],
        "activityBar.border": P["crust"],
        "activityBar.activeBorder": P["blue"],
        "activityBar.dropBorder": P["blue"] + "33",
        # side bar
        "sideBar.background": P["mantle"],
        "sideBar.foreground": text,
        "sideBar.border": P["mantle"],
        "sideBarTitle.foreground": P["blue"],
        "sideBarSectionHeader.background": P["mantle"],
        "sideBarSectionHeader.foreground": text,
        # editor groups & tabs
        "editorGroup.border": P["crust"],
        "editorGroup.dropBackground": P["surface0"] + "80",
        "editorGroupHeader.tabsBackground": P["crust"],
        "editorGroupHeader.noTabsBackground": P["crust"],
        "tab.activeBackground": base,
        "tab.activeForeground": text,
        "tab.activeBorder": base,
        "tab.activeBorderTop": named_color(named, "TAB_UNDERLINE", P["mauve"]),
        "tab.inactiveBackground": P["mantle"],
        "tab.inactiveForeground": P["overlay0"],
        "tab.unfocusedActiveForeground": P["subtext0"],
        "tab.unfocusedInactiveForeground": P["overlay0"],
        "tab.border": P["mantle"],
        "tab.hoverBackground": P["surface0"] + "60",
        "tab.activeModifiedBorder": named_color(
            named, "MODIFIED_TAB_ICON", P["blue"]),
        "editorPane.background": base,
        # editor
        "editor.background": base,
        "editor.foreground": text,
        "editorLineNumber.foreground": line_no,
        "editorLineNumber.activeForeground": line_no_active,
        "editorCursor.foreground": caret,
        "editorCursor.background": base,
        "editor.selectionBackground": selection,
        "editor.selectionHighlightBackground": search + "80",
        "editor.inactiveSelectionBackground": selection + "80",
        "editor.wordHighlightBackground": P["surface1"] + "70",
        "editor.wordHighlightStrongBackground": P["surface2"] + "70",
        "editor.findMatchBackground": P["surface2"],
        "editor.findMatchHighlightBackground": search + "90",
        "editor.findRangeHighlightBackground": P["surface1"] + "66",
        "editor.lineHighlightBackground": line_hl,
        "editor.rangeHighlightBackground": P["surface1"] + "50",
        "editorWhitespace.foreground": whitespace + "66",
        "editorIndentGuide.background1": indent,
        "editorIndentGuide.activeBackground1": indent_active,
        "editorRuler.foreground": ruler,
        "editorBracketMatch.background": base,
        "editorBracketMatch.border": brace_match,
        "editorCodeLens.foreground": P["overlay0"],
        "editorError.foreground": P["red"],
        "editorWarning.foreground": P["peach"],
        "editorInfo.foreground": P["sky"],
        "editorHint.foreground": P["teal"],
        "editorGutter.background": base,
        "editorGutter.modifiedBackground": named_color(
            named, "MODIFIED_LINES_COLOR", P["peach"]),
        "editorGutter.addedBackground": named_color(
            named, "ADDED_LINES_COLOR", P["green"]),
        "editorGutter.deletedBackground": named_color(
            named, "DELETED_LINES_COLOR", P["maroon"]),
        # bracket pair colorization (matches the .icls rainbow brackets)
        "editorBracketHighlight.foreground1": P["red"],
        "editorBracketHighlight.foreground2": P["peach"],
        "editorBracketHighlight.foreground3": P["yellow"],
        "editorBracketHighlight.foreground4": P["green"],
        "editorBracketHighlight.foreground5": P["sapphire"],
        "editorBracketHighlight.foreground6": P["mauve"],
        "editorBracketHighlight.unexpectedBracket.foreground": P["red"],
        # overview ruler
        "editorOverviewRuler.border": P["crust"] + "00",
        "editorOverviewRuler.findMatchForeground": P["surface2"],
        "editorOverviewRuler.modifiedForeground": P["blue"],
        "editorOverviewRuler.addedForeground": P["green"],
        "editorOverviewRuler.deletedForeground": P["maroon"],
        "editorOverviewRuler.errorForeground": P["red"],
        "editorOverviewRuler.warningForeground": P["peach"],
        # sticky scroll
        "editorStickyScroll.background": named_color(
            named, "STICKY_LINES_BACKGROUND", P["mantle"]),
        "editorStickyScrollHover.background": P["surface0"],
        # widgets
        "editorWidget.background": P["mantle"],
        "editorWidget.foreground": text,
        "editorWidget.border": P["surface2"],
        "editorSuggestWidget.background": P["mantle"],
        "editorSuggestWidget.border": P["surface2"],
        "editorSuggestWidget.foreground": text,
        "editorSuggestWidget.highlightForeground": P["blue"],
        "editorSuggestWidget.selectedBackground": P["surface0"],
        "editorHoverWidget.background": P["mantle"],
        "editorHoverWidget.border": P["surface2"],
        "editorGhostText.foreground": P["overlay0"],
        "peekView.border": P["blue"],
        "peekViewEditor.background": P["mantle"],
        "peekViewEditor.matchHighlightBackground": P["surface2"],
        "peekViewResult.background": P["mantle"],
        "peekViewResult.matchHighlightBackground": P["surface2"],
        "peekViewResult.selectionBackground": P["surface0"],
        "peekViewTitle.background": P["mantle"],
        "peekViewTitleDescription.foreground": P["subtext0"],
        "peekViewTitleLabel.foreground": P["blue"],
        # inlay hints
        "editorInlayHint.foreground": P["overlay1"],
        "editorInlayHint.background": P["surface0"] + "55",
        # panel
        "panel.background": base,
        "panel.border": P["crust"],
        "panelTitle.activeBorder": P["blue"],
        "panelTitle.activeForeground": text,
        "panelTitle.inactiveForeground": P["overlay0"],
        # status bar
        "statusBar.background": P["crust"],
        "statusBar.foreground": P["text"],
        "statusBar.border": P["crust"],
        "statusBar.noFolderBackground": P["crust"],
        "statusBar.debuggingBackground": P["peach"],
        "statusBar.debuggingForeground": P["crust"],
        "statusBarItem.remoteBackground": P["blue"],
        "statusBarItem.remoteForeground": P["crust"],
        "statusBarItem.hoverBackground": P["surface0"] + "60",
        "statusBarItem.errorBackground": P["crust"],
        "statusBarItem.errorForeground": P["red"],
        "statusBarItem.warningBackground": P["crust"],
        "statusBarItem.warningForeground": P["peach"],
        # title bar
        "titleBar.activeBackground": P["crust"],
        "titleBar.activeForeground": text,
        "titleBar.inactiveBackground": P["crust"],
        "titleBar.inactiveForeground": P["overlay0"],
        "titleBar.border": P["crust"],
        # menus
        "menu.background": P["mantle"],
        "menu.foreground": text,
        "menu.selectionBackground": P["surface0"],
        "menu.selectionForeground": text,
        "menu.separatorBackground": P["surface2"],
        "menubar.selectionBackground": P["surface0"],
        # command center / quick input (the command palette)
        "quickInput.background": P["mantle"],
        "quickInput.foreground": text,
        "quickInputList.focusBackground": P["surface0"],
        "quickInputList.focusForeground": text,
        "pickerGroup.border": P["surface2"],
        "pickerGroup.foreground": P["blue"],
        # breadcrumbs (RubyMine navigation bar)
        "breadcrumb.background": base,
        "breadcrumb.foreground": P["overlay1"],
        "breadcrumb.focusForeground": text,
        "breadcrumb.activeSelectionForeground": P["blue"],
        "breadcrumbPicker.background": P["mantle"],
        # notifications
        "notificationCenterHeader.background": P["mantle"],
        "notifications.background": P["mantle"],
        "notifications.border": P["surface2"],
        "notificationLink.foreground": P["blue"],
        # git decorations
        "gitDecoration.addedResourceForeground": P["green"],
        "gitDecoration.modifiedResourceForeground": P["blue"],
        "gitDecoration.deletedResourceForeground": P["maroon"],
        "gitDecoration.untrackedResourceForeground": named_color(
            named, "FILESTATUS_UNKNOWN", P["peach"]),
        "gitDecoration.ignoredResourceForeground": P["overlay0"],
        "gitDecoration.conflictingResourceForeground": P["mauve"],
        "gitDecoration.stageModifiedResourceForeground": P["lavender"],
        # minimap
        "minimap.findMatchHighlight": P["surface2"],
        "minimap.selectionHighlight": selection,
        "minimapSlider.background": P["surface1"] + "60",
        "minimapSlider.hoverBackground": P["surface2"] + "60",
        # terminal (from CONSOLE_* ANSI mapping)
        "terminal.foreground": text,
        "terminal.background": base,
        "terminalCursor.foreground": caret,
        "terminal.ansiBlack": ansi(attrs, "CONSOLE_BLACK_OUTPUT", P["surface1"]),
        "terminal.ansiRed": ansi(attrs, "CONSOLE_RED_OUTPUT", P["red"]),
        "terminal.ansiGreen": ansi(attrs, "CONSOLE_GREEN_OUTPUT", P["green"]),
        "terminal.ansiYellow": ansi(attrs, "CONSOLE_YELLOW_OUTPUT", P["yellow"]),
        "terminal.ansiBlue": ansi(attrs, "CONSOLE_BLUE_OUTPUT", P["blue"]),
        "terminal.ansiMagenta": ansi(attrs, "CONSOLE_MAGENTA_OUTPUT", P["pink"]),
        "terminal.ansiCyan": ansi(attrs, "CONSOLE_CYAN_OUTPUT", P["teal"]),
        "terminal.ansiWhite": ansi(attrs, "CONSOLE_WHITE_OUTPUT", P["subtext1"]),
        "terminal.ansiBrightBlack": ansi(
            attrs, "CONSOLE_DARKGRAY_OUTPUT", P["surface2"]),
        "terminal.ansiBrightRed": P["red"],
        "terminal.ansiBrightGreen": P["green"],
        "terminal.ansiBrightYellow": P["yellow"],
        "terminal.ansiBrightBlue": P["blue"],
        "terminal.ansiBrightMagenta": P["pink"],
        "terminal.ansiBrightCyan": P["teal"],
        "terminal.ansiBrightWhite": ansi(
            attrs, "CONSOLE_GRAY_OUTPUT", P["subtext0"]),
    }
    return c


def ansi(attrs, key, fallback):
    return hexc((attrs.get(key) or {}).get("FOREGROUND")) or fallback


def main():
    named, attrs = parse_icls(ICLS)
    theme = {
        "$schema": "vscode://schemas/color-theme",
        "name": "Catppuccin Frappe PrideCat",
        "type": "dark",
        "semanticHighlighting": True,
        "colors": build_workbench(named, attrs),
        "tokenColors": build_token_colors(attrs),
    }
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w") as f:
        json.dump(theme, f, indent=2)
        f.write("\n")
    print(f"Wrote {OUT}")
    print(f"  {len(theme['colors'])} workbench colors, "
          f"{len(theme['tokenColors'])} token rules")


if __name__ == "__main__":
    main()

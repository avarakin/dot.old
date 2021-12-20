# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
terminal = guess_terminal()
fg_color="#d75f5f"


keys = [
    # Switch between windows
    Key([mod], "Left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Tab", lazy.layout.next(), desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(),  desc="Move window to the left"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),



    # RESIZE UP, DOWN, LEFT, RIGHT
    Key([mod, "control"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),



    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], 'f', lazy.window.toggle_fullscreen()),



    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),

    # System Commands
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),



    #Launchers
    Key(["mod1"], "space", lazy.spawn("rofi -show drun")),
    Key([mod], "space", lazy.spawncmd(), desc="Command prompt widget"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn("google-chrome-stable"), desc="Launch Browser"),
    Key([mod], "c", lazy.spawn("code"),                 desc="Launch Code"),
    Key([mod], "z", lazy.spawn("zoom"),                 desc="Launch Code"),
    Key([mod], "p", lazy.spawn("/opt/PixInsight/bin/PixInsight.sh -n"),  desc="Launch PixInsight"),
    Key([mod], "t", lazy.spawn("teams"), desc="Launch Teams"),    
#    Key([mod], "f", lazy.spawn("freecad"), desc="Launch FreeCAD"),    
    Key([mod], "j", lazy.spawn("joplin-desktop"), desc="Launch Joplin"),
    Key([mod], "v", lazy.spawn("vncviewer"), desc="VNC"),
    Key([mod], "s", lazy.spawn("systemctl suspend"), desc="Suspend"),
]

#groups = [Group(i) for i in "123456789"]

groups = [
        Group(name='1', matches=None, spawn='google-chrome-stable', layout="MonadTall", label='1:main'),
        Group(name='2', matches=[Match(wm_class=["PixInsight"])], spawn='/opt/PixInsight/bin/PixInsight.sh -n=3', layout="max", label='2:PI1'),
#        Group(name='3', matches=None, spawn='/opt/PixInsight/bin/PixInsight.sh -n=4', layout="max", label='3:PI2'),
        Group(name='3', matches=[Match(wm_class=["code-oss"])], spawn='code', layout="MonadTall", label='3:Dev'),
        Group(name='4', matches=None, spawn='vncviewer', layout="MonadTall", label='4:Astro'),

    ]


for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

layouts = [
    #layout.Columns(border_focus_stack=['#d75f5f', '#8f3d3d'], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    #layout.Stack(num_stacks=2),
    #layout.Bsp(),
    #layout.Matrix(),
    layout.MonadTall(),
    #layout.MonadWide(),
    #layout.RatioTile(),
    #layout.Tile(),
    #layout.TreeTab(),
    #layout.VerticalTile(),
    #layout.Zoomy(),
]

widget_defaults = dict(
    font='Roboto Condensed',
    fontsize=16,
    padding=0,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
#                widget.LaunchBar(progs=[('Sleep', '', 'Exit menu')],
#                             default_icon=home + '/.local/share/icons/logout.png', **wid_defaults),
                widget.TaskList(),
#                widget.WindowName(),
                widget.Chord(
                    chords_colors={
#                widget.Sep(),
                        'launch': ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
#                widget.TextBox("default config", name="default"),
                widget.Sep(),
                widget.TextBox("Press &lt;M-r&gt; to spawn", foreground=fg_color),
                widget.Sep(),
		        widget.PulseVolume(emoji=True,foreground=fg_color),
                widget.Sep(),

                widget.KeyboardLayout(configured_keyboards=['us', 'ru'],foreground=fg_color),
                widget.Sep(),
                widget.CheckUpdates(display_format="{updates} Pkg Updates",
                                    colour_no_updates=fg_color,
                                    colour_have_updates=fg_color,
                                    distro='Arch',
                                    execute=lazy.spawn("tkpacman"),
                                    foreground=fg_color),
#                widget.Sep(),
#                widget.СPUGraph(),
                widget.Sep(),
                widget.Systray(),
                widget.Sep(),
                widget.Clock(format='%Y-%m-%d %a %I:%M:%S %p'),
                widget.QuickExit(),
            ],
            28,
        ),
    ),
]


# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

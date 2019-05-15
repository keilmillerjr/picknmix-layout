// --------------------
// Load Modules
// --------------------

fe.load_module("helpers");
fe.load_module("preserve-art");
fe.load_module("fade");
fe.load_module("shader");

// --------------------
// Layout User Options
// --------------------

local userConfig = {
	order = 0,
	prefix = "---------- ",
	postfix = " ----------",
}

class UserConfig {
	</ label=userConfig.prefix + "GENERAL" + userConfig.postfix,
		help="mvscomplete Layout",
		order=userConfig.order++ />
	general="";

		</ label="Force 4:3 aspect",
			help="Force video to play in 4:3 aspect ratio.",
			options="Yes, No",
			order=userConfig.order++ />
		force="No";

		</ label="Format Game Title",
			help="Remove parenthesis, slashes, brackets and following text from game title.",
			options="Yes, No",
			order=userConfig.order++ />
		formatTitle="Yes";

	</ label=userConfig.prefix + "ARTWORK" + userConfig.postfix,
		order=userConfig.order++ />
	artwork="";

		</ label="Video Artwork Label",
			help="Label that identifies the background video/snap artwork.",
			order=userConfig.order++ />
		videoLabel="snap";

		</ label="Video Artwork Audio",
			help="Audio when video artwork is playing.",
			options="On, Off",
			order=userConfig.order++ />
		videoAudio="On";

		</ label="Logo Artwork Label",
			help="Label that identifies the logo artwork displayed over the video artwork.",
			order=userConfig.order++ />
		logoLabel="wheel";

	</ label=userConfig.prefix + "OSD" + userConfig.postfix,
		help="mvscomplete Layout",
		order=userConfig.order++ />
	osd="";

		</ label="Clock Delay",
			help="Delay (milliseconds) when the On Screen Display disappears.",
			order=userConfig.order++ />
		osdClockDelay="2000";

		</ label="Effect Type",
			help="Effect type when the On Screen Display disappears.",
			options="collapse, compress, fade, shrink, disappear",
			order=userConfig.order++ />
		osdEffectType="disappear";

		</ label="Effect Duration",
			help="Effect duration (milliseconds) when the On Screen Display disappears.",
			order=userConfig.order++ />
		osdEffectDuration="200";

	</ label=userConfig.prefix + "SHADERS" + userConfig.postfix,
		order=userConfig.order++ />
	shaders="";

		</ label="CRT Shader",
			help="CRT Shader applied.",
			options="Disabled, Crt Cgwg, Crt Lottes",
			order=userConfig.order++ />
		crtShader="Disabled";

		</ label="Enable Bloom Shader",
			help="Bloom applied with CRT shaders.",
			options="Yes, No",
			order=userConfig.order++ />
		bloom="No";
}
local userConfig = fe.get_config();

// --------------------
// Config
// --------------------

fe.layout.font = "consola-bold-uppercase.ttf";

local flw = fe.layout.width;
local flh = fe.layout.height;

local config = {};

// ---------- Test

config.testText <- {
	margin = 0,
}

// ---------- Main

config.containerParent <- {
	x = toBool(userConfig["force"]) ? (flw - matchAspect(4, 3, "height", flh))/2 : 0,
	y = 0,
	width = toBool(userConfig["force"]) ? matchAspect(4, 3, "height", flh) : flw,
	height = flh,
};

config.container <- {
	x = 0,
	y = 0,
	width = toBool(userConfig["force"]) ? matchAspect(4, 3, "height", flh) : flw,
	height = flh,
};

config.video <- {
	x = 0,
	y = 0,
	width = config.container.width,
	height = config.container.height,
	trigger = Transition.EndNavigation,
};
	if (!toBool(userConfig["videoAudio"])) config.video.video_flags <- Vid.NoAudio;

config.logo <- {
	padding = per(4, config.container.width),
	height = per(20, config.container.height),
	preserve_aspect_ratio = true,
	trigger = Transition.EndNavigation,
};
	config.logo.y <- config.container.height-config.logo.padding-config.logo.height;
	config.logo.width <- matchAspect(16, 7, "h", config.logo.height); // Aspect based on average size of 400x175
	config.logo.x <- config.container.width-config.logo.padding*1.5-config.logo.width;

// ---------- Menu

config.menu <- {
	width = per(76, config.container.width),
	height = per(64, config.container.height),
};
	config.menu.x <- config.container.width/2-config.menu.width/2;
	config.menu.y <- config.container.height/2-config.menu.height/2;;

config.menuBorder <- {
	x = 0,
	y = 0,
	width = config.menu.width,
	height = config.menu.height,
	file_name = pixelPath,
	rgb = [224, 244, 0],
};

config.menuBackground <- {
	x = per(1, config.menu.width),
	y = per(1, config.menu.width),
	width = per(98, config.menu.width),
	height = config.menu.height-per(2, config.menu.width),
	file_name = pixelPath,
	rgb = [16, 16, 16],
};

config.menuRows <- {
	padding = per(3, config.menu.width),
};
	config.menuRows.rowWidth <- config.menu.width-config.menuRows.padding*2;
	config.menuRows.rowHeight <- (config.menu.height-config.menuRows.padding*2)/14;

config.menuSelectedTop <- {
	x = config.menuRows.padding,
	width = config.menuRows.rowWidth,
	height = per(0.66, config.menu.width),
	file_name = pixelPath,
	rgb = [224, 224, 224],
};
	config.menuSelectedTop.y <- config.menuRows.padding+config.menuRows.rowHeight*5.5-config.menuSelectedTop.height/2,

config.menuSelectedBottom <- {
	x = config.menuRows.padding,
	width = config.menuRows.rowWidth,
	height = per(0.66, config.menu.width),
	file_name = pixelPath,
	rgb = [224, 224, 224],
};
	config.menuSelectedBottom.y <- config.menuRows.padding+config.menuRows.rowHeight*8.5-config.menuSelectedBottom.height/2,


// ---------- Menu Title

config.title <- [];
	for (local i=0; i<13; i++) {
		config.title.push("");
	}

config.title[0] = {
	x = config.menuRows.padding,
	y = config.menuRows.padding,
	width = config.menuRows.rowWidth,
	height = config.menuRows.rowHeight,
	rgb = [40, 40, 40],
	align = Align.MiddleCentre,
};

config.title[1] = {
	x = config.menuRows.padding,
	y = config.menuRows.padding+config.menuRows.rowHeight,
	width = config.menuRows.rowWidth,
	height = config.menuRows.rowHeight,
	rgb = [56, 56, 56],
	bg_rgb = [24, 24, 24],
	align = Align.MiddleCentre,
};

config.title[2] = {
	x = config.menuRows.padding,
	y = config.menuRows.padding+config.menuRows.rowHeight*2,
	width = config.menuRows.rowWidth,
	height = config.menuRows.rowHeight,
	rgb = [80, 80, 80],
	bg_rgb = [32, 32, 32],
	align = Align.MiddleCentre,
};

config.title[3] = {
	x = config.menuRows.padding,
	y = config.menuRows.padding+config.menuRows.rowHeight*3,
	width = config.menuRows.rowWidth,
	height = config.menuRows.rowHeight,
	rgb = [96, 96, 96],
	bg_rgb = [40, 40, 40],
	align = Align.MiddleCentre,
};

config.title[4] = {
	x = config.menuRows.padding,
	y = config.menuRows.padding+config.menuRows.rowHeight*4,
	width = config.menuRows.rowWidth,
	height = config.menuRows.rowHeight,
	rgb = [96, 96, 96],
	bg_rgb = [40, 40, 40],
	align = Align.MiddleCentre,
};

config.title[5] = {
	x = config.menuRows.padding,
	y = config.menuRows.padding+config.menuRows.rowHeight*6,
	width = config.menuRows.rowWidth,
	height = config.menuRows.rowHeight*2,
	rgb = [224, 224, 224],
	align = Align.MiddleCentre,
};

config.title[6] = {
	x = config.menuRows.padding,
	y = config.menuRows.padding+config.menuRows.rowHeight*9,
	width = config.menuRows.rowWidth,
	height = config.menuRows.rowHeight,
	rgb = [96, 96, 96],
	bg_rgb = [40, 40, 40],
};

config.title[7] = {
	x = config.menuRows.padding,
	y = config.menuRows.padding+config.menuRows.rowHeight*10,
	width = config.menuRows.rowWidth,
	height = config.menuRows.rowHeight,
	rgb = [96, 96, 96],
	bg_rgb = [40, 40, 40],
	align = Align.MiddleCentre,
};

config.title[8] = {
	x = config.menuRows.padding,
	y = config.menuRows.padding+config.menuRows.rowHeight*11,
	width = config.menuRows.rowWidth,
	height = config.menuRows.rowHeight,
	rgb = [80, 80, 80],
	bg_rgb = [32, 32, 32],
	align = Align.MiddleCentre,
};

config.title[9] = {
	x = config.menuRows.padding,
	y = config.menuRows.padding+config.menuRows.rowHeight*12,
	width = config.menuRows.rowWidth,
	height = config.menuRows.rowHeight,
	rgb = [56, 56, 56],
	bg_rgb = [24, 24, 24],
	align = Align.MiddleCentre,
};

config.title[10] = {
	x = config.menuRows.padding,
	y = config.menuRows.padding+config.menuRows.rowHeight*13,
	width = config.menuRows.rowWidth,
	height = config.menuRows.rowHeight,
	rgb = [40, 40, 40],
	align = Align.MiddleCentre,
};

// ---------- Menu Group

config.platform <- {
	x = config.menuRows.padding,
	y = config.menuRows.padding,
	width = config.menuRows.rowWidth,
	height = config.menuRows.rowHeight,
	rgb = [224, 224, 224],
	bg_rgb = [16, 16, 16],
	align = Align.TopLeft,
	margin = 0,
};

config.filter <- {
	x = config.menuRows.padding,
	y = config.menuRows.padding+config.menuRows.rowHeight*13,
	width = config.menuRows.rowWidth,
	height = config.menuRows.rowHeight,
	msg = "[FilterName]",
	rgb = [224, 224, 224],
	bg_rgb = [16, 16, 16],
	align = Align.BottomRight,
	margin = 0,
};

// --------------------
// Functions
// --------------------

function formatTitle(index_offset=0) {
	if (toBool(userConfig.formatTitle) && (fe.game_info(Info.Title, index_offset) != "")) {
		local s = split(fe.game_info(Info.Title, index_offset), "(/[");
		return rstrip(s[0]).toupper();
	}
	else return fe.game_info(Info.Title, index_offset).toupper();
}

function formatPlatform() {
	if (fe.list.display_index < 0) return "PICKnMIX";
	return fe.list.name.toupper();
}

// --------------------
// Layout
// --------------------

// ---------- Test

local testText = fe.add_text("", 0, 0, flw, 1);

// ---------- Container

local containerParent = fe.add_surface(config.containerParent.width, config.containerParent.height);
	setProps(containerParent, config.containerParent);

local container = containerParent.add_surface(config.container.width, config.container.height);
	setProps(container, config.container);

// ---------- Video

local video = container.add_artwork(userConfig["videoLabel"], -1, -1, 1, 1);
	setProps(video, config.video);

// ---------- Logo

class PreserveLogo extends PreserveArt {
	function _set(idx, val) {
		if (idx == "index_offset") art.index_offset = val;
		else if (idx == "filter_offset") art.filter_offset = val;
		else if (idx == "file_name") art.file_name = val;
		else if (idx == "trigger") art.trigger = val;
		else surface[idx] = val;
	}

	function onTransition(ttype, var, ttime) {
		if (ttype == Transition.StartLayout || ttype == Transition.FromOldSelection || ttype == Transition.ToNewList || ttype == Transition.EndNavigation) request_size = true;
	}
}

local logo = PreserveLogo(userConfig["logoLabel"], config.logo.x, config.logo.y, config.logo.width, config.logo.height, container);
	logo.trigger = Transition.EndNavigation;
	logo.set_fit_or_fill("fit");
	logo.set_anchor(::Anchor.Bottom);

// ---------- Menu

local menu = container.add_surface(config.menu.width, config.menu.height);
	setProps(menu, config.menu);

local menuBorder = menu.add_image(pixelPath);
	setProps(menuBorder, config.menuBorder);

local menuBackground = menu.add_image(pixelPath);
	setProps(menuBackground, config.menuBackground);

local menuSelectedTop = menu.add_image(pixelPath);
	setProps(menuSelectedTop, config.menuSelectedTop);

local menuSelectedBottom = menu.add_image(pixelPath);
	setProps(menuSelectedBottom, config.menuSelectedBottom);

local title = [];
	for (local i=0; i<11; i++) {
		title.push(menu.add_text("", -1, -1, 1, 1));
		setProps(title[i], config.title[i]);
	}

local platform = menu.add_text("", -1, -1, 1, 1);
	setProps(platform, config.platform);

local filter = menu.add_text("", -1, -1, 1, 1);
	setProps(filter, config.filter);

// --------------------
// Shaders
// --------------------

local shaderCrtLottes = CrtLottes();
local shaderCrtCgwg = CrtCgwg();
local shaderBloom = Bloom();

switch (userConfig["crtShader"]) {
	case "Crt Lottes":
		if (toBool(userConfig["bloom"])) containerParent.shader = shaderBloom.shader;
		container.shader = shaderCrtLottes.shader;
		break;
	case "Crt Cgwg":
		if (toBool(userConfig["bloom"])) containerParent.shader = shaderBloom.shader;
		container.shader = shaderCrtCgwg.shader;
		break;
	default:
		containerParent.shader = fe.add_shader(Shader.Empty);
		container.shader = fe.add_shader(Shader.Empty);
		break;
}

// --------------------
// Transitions
// --------------------

function transitions(ttype, var, ttime) {
	switch (ttype) {
		case Transition.ToNewList:
			// ---------- Platform Transition
			platform.msg = formatPlatform();
			testText.height = config.platform.height;
			testText.msg = platform.msg;
			local platformCharWidth = testText.msg_width;;
			if (platformCharWidth < config.platform.width) {
				platform.width = platformCharWidth;
			}
			else platform.width = config.platform.width;

			// ---------- Filter Transition
			testText.height = config.filter.height;
			testText.msg = filter.msg;
			local filterCharWidth = testText.msg_width;
			if (filterCharWidth < config.filter.width) {
				filter.width = filterCharWidth;
				filter.x = config.filter.x+config.filter.width-filter.width;
			}
			else {
				filter.width = config.filter.width;
				filter.x = config.filter.x;
			}
			break;
	}

	// ---------- Favorite Transition
	switch (ttype) {
		case Transition.ToNewSelection:
		case Transition.FromOldSelection:
		case Transition.ToNewList:
		case Transition.ChangedTag:
			title[0].msg = formatTitle(-5);
			title[1].msg = formatTitle(-4);
			title[2].msg = formatTitle(-3);
			title[3].msg = formatTitle(-2);
			title[4].msg = formatTitle(-1);
			title[5].msg = formatTitle();
				fe.game_info(Info.Favourite) == "1" ? title[5].set_rgb(224, 244, 0) : title[5].set_rgb(224, 224, 224);
			title[6].msg = formatTitle(1);
			title[7].msg = formatTitle(2);
			title[8].msg = formatTitle(3);
			title[9].msg = formatTitle(4);
			title[10].msg = formatTitle(5);
			break;
	}
	return false;
}
fe.add_transition_callback("transitions");

// --------------------
// OSD
// --------------------

class OSD {
	clock = {
		current = 0,
		delay = null,
		signal = 0,
	};
	object = null;
	properties = {
		x = null,
		y = null,
		width = null,
		height = null,
		alpha = null,
	};
	effect = {
		duration = null,
		type = [
			"collapse",
			"compress",
			"fade",
			"shrink",
			"disappear",
		],
	};

	constructor(obj, cd=2000, et="disappear", ed=200) {
		// ----- clock.delay -----
		try {
			clock.delay = cd.tointeger();
			assert(clock.delay >= 1);
		}
		catch(e) {
			printL("ERROR in PICKnMIX Layout: OSD - improper delay time, switching to default value");
			clock.delay = 2000;
		}

		// ----- object and properties -----
		object = obj;
			try {
				properties.x = object.x;
				properties.y = object.y;
				properties.width = object.width;
				properties.height = object.height;
				properties.alpha = object.alpha;
			}
			catch(e) { printL("ERROR in PICKnMIX Layout: OSD - improper object") }

		// ----- effect.type -----
		try {
			assert(effect.type.find(strip(et)) != null);
			effect.type = strip(et);
		}
		catch (e) {
			printL("ERROR in PICKnMIX Layout: OSD - improper effect, switching to default value");
			effect.type = "disappear";
		}

		// ----- effect.duration -----
		try {
			effect.duration = ed.tointeger();
			assert(effect.duration >= 1);
		}
		catch(e) {
			printL("ERROR in PICKnMIX Layout: OSD - improper effect duration time, switching to default value");
			effect.duration = 200;
		}

		// ----- callbacks and handlers -----
		fe.add_ticks_callback(this, "ticks");
		fe.add_transition_callback(this, "transitions");
		fe.add_signal_handler(this, "signals");
	}

	// ----- Ticks Callback -----

	function ticks(ttime) {
		// Current Time (accessible from transitions)
		clock.current = ttime;

		// Engage
		if (clock.current >= clock.signal+clock.delay && clock.current <= clock.signal+clock.delay+effect.duration) {
			switch (effect.type) {
				case "collapse":
					collapse();
					break;
				case "compress":
					compress();
					break;
				case "fade":
					fade();
					break;
				case "shrink":
					shrink();
					break;
				case "disappear":
				default:
					disappear();
					break;
			}
		}
		if (clock.current > clock.signal+clock.delay+effect.duration) disappear(); // Disappear if effect did not finish
	}

	// ----- Transition Callback -----

	function transitions(ttype, var, ttime) {
		clock.signal = clock.current;
		return false;
	}

	// ----- Signals Handler -----

	function signals(signal_str) {
		switch (signal_str) {
			case "prev_game":
			case "next_game":
			case "prev_page":
			case "next_page":
			case "prev_display":
			case "next_display":
			case "prev_filter":
			case "next_filter":
			case "random_game":
			case "add_favorite":
			case "prev_favorite":
			case "next_favorite":
			case "add_tags":
			case "prev_letter":
			case "next_letter":
				restore();
				break;
		}
		return false;
	}

	// ----- Collapse -----

	function collapse() {
		object.height = properties.height-properties.height*(clock.current-clock.signal-clock.delay)/effect.duration;
		object.y = properties.y+properties.height*(clock.current-clock.signal-clock.delay)/effect.duration/2;
	}

	// ----- Compress -----

	function compress() {
		object.height = properties.height-properties.height*(clock.current-clock.signal-clock.delay)/effect.duration;
		object.y = properties.y+properties.height*(clock.current-clock.signal-clock.delay)/effect.duration/2;
		object.width = properties.width-properties.height*(clock.current-clock.signal-clock.delay)/effect.duration;
		object.x = properties.x+properties.width*(clock.current-clock.signal-clock.delay)/effect.duration/3;
	}


	// ----- Fade -----

	function fade() {
		object.alpha = -255*(clock.current-clock.signal-clock.delay)/effect.duration;
	}

	// ----- Shrink -----

	function shrink() {
		object.height = properties.height-properties.height*(clock.current-clock.signal-clock.delay)/effect.duration;
		object.y = properties.y+properties.height*(clock.current-clock.signal-clock.delay)/effect.duration/2;
		object.width = properties.width-properties.width*(clock.current-clock.signal-clock.delay)/effect.duration;
		object.x = properties.x+properties.width*(clock.current-clock.signal-clock.delay)/effect.duration/2;
	}

	// ----- Disappear -----

	function disappear() {
		object.visible = false;
	}

	// ----- Restore -----

	function restore() {
		object.x = properties.x;
		object.y = properties.y;
		object.width = properties.width;
		object.height = properties.height;
		object.visible = true;
		object.alpha = properties.alpha;
	}
}
OSD(menu, userConfig.osdClockDelay, userConfig.osdEffectType);

// --------------------
// Cycle
// --------------------

class Cycle {
	object = null;
	clock = {
		current = 0,
		signal = 0,
		delay = 60000,
	};

	constructor(obj) {
		object = obj;

		fe.add_ticks_callback(this, "ticks");
		fe.add_transition_callback(this, "transitions");
	}

	// ----- Ticks Callback -----

	function ticks(ttime) {
		// Current Time (accessible from transitions)
		clock.current = ttime;

		// Engage
		if (object.video_duration == 0) { // Object is an image or not drawn yet
			if (clock.current >= clock.signal+clock.delay) next();
		}
	 	else if (clock.current >= clock.signal+object.video_duration) next(); // Object is a video
	}

	// ----- Transition Callback -----

	function transitions(ttype, var, ttime) {
		clock.signal = clock.current;
		return false;
	}

	// ----- Next -----

	function next() {
		fe.list.index = randInt(fe.list.size-1);
	}
}
Cycle(video);

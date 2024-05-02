static const char *colorname[] = {
	/* 8 normal colors */


	"black",
	"red3",
	"#5faf00",
	"yellow3",
	"blue2",
	"magenta3",
	"cyan3",
	"gray90",

	/* 8 bright colors */
	"gray50",
	"red",
	"#afd700",
	"yellow",
	"#5c5cff",
	"magenta",
	"cyan",
	"white",

	[255] = 0,

	/* more colors can be added after 255 to use with DefaultXX */
	"#cccccc",
	"#555555",
	"gray90", /* default foreground colour */
	"#000000", /* default background colour */
};
/* bg opacity */
float alpha = 0.8;


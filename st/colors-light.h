static const char *colorname[] = {
	/* 8 normal colors */
	"black",
	"red3",
	"#008800",
	"yellow3",
	"blue2",
	"magenta3",
	"#8888aa",
	"#222222",

	/* 8 bright colors */
	"#222222",
	"red",
	"#006600",
	"yellow",
	"#5c5cff",
	"magenta",
	"#444455",
	"#333333",

	[255] = 0,

	/* more colors can be added after 255 to use with DefaultXX */
	"#222222",
	"#222222",
	"#000000", /* default foreground colour */
	"#ffefef", /* default background colour */
};
/* bg opacity */
float alpha = 0.8;

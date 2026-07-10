const C3 = self.C3;
self.C3_GetObjectRefTable = function () {
	return [
		C3.Plugins.Sprite,
		C3.Plugins.Text,
		C3.Behaviors.Tween,
		C3.Behaviors.Timer,
		C3.Plugins.NinePatch,
		C3.Plugins.Mouse,
		C3.Plugins.TiledBg
	];
};
self.C3_JsPropNameTable = [
	{WordTextBG: 0},
	{gridX: 0},
	{gridY: 0},
	{Letter: 0},
	{Tween: 0},
	{WordText: 0},
	{ButtonNew: 0},
	{elapsedTime: 0},
	{Timer: 0},
	{TimerText: 0},
	{Background: 0},
	{startingX: 0},
	{startingY: 0},
	{dirX: 0},
	{dirY: 0},
	{length: 0},
	{word: 0},
	{Marker: 0},
	{Mouse: 0},
	{Popup: 0},
	{ButtonYes: 0},
	{ButtonNo: 0},
	{TextMessage: 0},
	{BotFader: 0},
	{TopFader: 0}
];

self.InstanceType = {
	WordTextBG: class extends self.ISpriteInstance {},
	Letter: class extends self.ITextInstance {},
	WordText: class extends self.ITextInstance {},
	ButtonNew: class extends self.ISpriteInstance {},
	TimerText: class extends self.ITextInstance {},
	Background: class extends self.ISpriteInstance {},
	Marker: class extends self.I9PatchInstance {},
	Mouse: class extends self.IInstance {},
	Popup: class extends self.ISpriteInstance {},
	ButtonYes: class extends self.ISpriteInstance {},
	ButtonNo: class extends self.ISpriteInstance {},
	TextMessage: class extends self.ITextInstance {},
	BotFader: class extends self.ITiledBackgroundInstance {},
	TopFader: class extends self.ITiledBackgroundInstance {}
}
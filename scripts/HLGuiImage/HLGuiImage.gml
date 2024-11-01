
/**
 * An image, which displays the given sprite.
 * 
 * @param {Asset.GMSprite} sprite The index of the sprite to display.
 * @param {Real} [alpha] The alpha to draw the sprite at.
 */
function HLGuiImage(sprite, alpha = 1) : HLGuiWidget() constructor {
	
	self.sprite = sprite;
	self.spriteWidth = sprite_get_width(self.sprite);
	self.spriteHeight = sprite_get_height(self.sprite);
	self.alpha = alpha;
	
	static measureHeight = function(width) {
		return (width / self.spriteWidth) * self.spriteHeight;
	};
	
	static draw = function(x, y, width, height) {
		
		if (self.alpha != 1) {
			HLGuiDrawUtils.setColour(c_white, self.alpha);
		}
		
		draw_sprite_stretched(self.sprite, 0, x, y, width, height);
		
		if (self.alpha != 1) {
			HLGuiDrawUtils.resetColour();
		}
		
	};
	
	static toString = function() {
		return $"{instanceof(self)}(sprite={sprite}, spriteWidth={spriteWidth}, spriteHeight={spriteHeight})";
	};
	
}

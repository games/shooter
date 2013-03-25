package threeshooter.dungeonadventure.components {
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;

	import starling.events.Event;

	public class TeamItemRenderer extends FeathersControl implements IListItemRenderer {

		protected var itemLabel:Label;
		protected var _index:int = -1;
		protected var _owner:List;
		protected var _data:Object;
		protected var _isSelected:Boolean;

		public function TeamItemRenderer() {
			super();
		}

		override protected function initialize():void {
			if (!itemLabel) {
				itemLabel = new Label();
				addChild(itemLabel);
			}
		}

		override protected function draw():void {
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if (dataInvalid) {
				this.commitData();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if (dataInvalid || sizeInvalid) {
				this.layout();
			}
		}

		protected function autoSizeIfNeeded():Boolean {
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if (!needsWidth && !needsHeight) {
				return false;
			}
			this.itemLabel.width = NaN;
			this.itemLabel.height = NaN;
			this.itemLabel.validate();
			var newWidth:Number = this.explicitWidth;
			if (needsWidth) {
				newWidth = this.itemLabel.width;
			}
			var newHeight:Number = this.explicitHeight;
			if (needsHeight) {
				newHeight = this.itemLabel.height;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		protected function commitData():void {
			if (this._data) {
				this.itemLabel.text = this._data.toString();
			} else {
				this.itemLabel.text = "";
			}
		}

		protected function layout():void {
			this.itemLabel.width = this.actualWidth;
			this.itemLabel.height = this.actualHeight;
		}

		public function get data():Object {
			return _data;
		}

		public function set data(value:Object):void {
			if (_data == value) {
				return;
			}
			_data = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}

		public function get index():int {
			return _index;
		}

		public function set index(value:int):void {
			if (_index == value) {
				return;
			}
			_index = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}

		public function get owner():List {
			return _owner;
		}

		public function set owner(value:List):void {
			if (_owner == value) {
				return;
			}
			_owner = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}

		public function get isSelected():Boolean {
			return _isSelected;
		}

		public function set isSelected(value:Boolean):void {
			if (_isSelected == value) {
				return;
			}
			_isSelected = value;
			invalidate(INVALIDATION_FLAG_SELECTED);
			dispatchEventWith(Event.CHANGE);
		}
	}
}

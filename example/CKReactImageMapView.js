// CKReactImageMapView.js
import React from 'react';
import PropTypes from 'prop-types';
import ReactNative, { requireNativeComponent, UIManager, NativeModules} from 'react-native';
const CKRNImageMapManager = NativeModules.CKRNImageMapManager;

class CKReactImageMapView extends React.Component {
  render() {
    return <CKReactImageMap ref={ref => this.imageMap = ref } {...this.props} />;
  }

  _getImageMapHandle = (): any => {
    return ReactNative.findNodeHandle(this.imageMap);
  };

  /**
   * Add a Marker 
  */
  addMarker = (marker) => {
    UIManager.dispatchViewManagerCommand(
      this._getImageMapHandle(),
      UIManager.CKRNImageMap.Commands.addMarker,
      [marker]
    );
  };

  /**
   * mark a Marker 
  */ 
  mark = (marker) => {
    UIManager.dispatchViewManagerCommand(
      this._getImageMapHandle(),
      UIManager.CKRNImageMap.Commands.mark,
      [marker]
    );
  };

  /**
   * unmark a Marker 
  */ 
  unmark = (marker) => {
    UIManager.dispatchViewManagerCommand(
      this._getImageMapHandle(),
      UIManager.CKRNImageMap.Commands.unmark,
      [marker]
    );
  };

  /**
   * mark a Marker 
  */ 
  checkMarked = (marker) => {
     return CKRNImageMapManager.checkMarked(this._getImageMapHandle(), marker)
  };

}

CKReactImageMapView.propTypes = {
  /**
   * A Boolean value that determines whether the user may use pinch
   * gestures to zoom in and out of the map.
   */
  mapName: PropTypes.string,
  imageURLString: PropTypes.string,
  markers: PropTypes.array,
  onClickAnnotation: PropTypes.func,
  mark: PropTypes.func,
  unmark: PropTypes.func,
  checkMarked: PropTypes.func,
};

var CKReactImageMap = requireNativeComponent('CKRNImageMap', CKReactImageMapView);

module.exports = CKReactImageMapView;
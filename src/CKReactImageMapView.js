// CKReactImageMapView.js
import React from 'react';
import PropTypes from 'prop-types';
import ReactNative, { requireNativeComponent, UIManager } from 'react-native';
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
      UIManager.CKReactImageMap.Commands.addMarker,
      [marker]
    );
  };

  /**
   * mark a Marker 
  */ 
  mark = (marker) => {
    UIManager.dispatchViewManagerCommand(
      this._getImageMapHandle(),
      UIManager.CKReactImageMap.Commands.mark,
      [marker]
    );
  };

  /**
   * unmark a Marker 
  */ 
  unmark = (marker) => {
    UIManager.dispatchViewManagerCommand(
      this._getImageMapHandle(),
      UIManager.CKReactImageMap.Commands.unmark,
      [marker]
    );
  };

  /**
   * mark a Marker 
  */ 
  checkMarked = (marker) => {
     return CKRNImageMapManager.checkMarked(this._getImageMapHandle())
  };

}

CKReactImageMapView.propTypes = {
  /**
   * A Boolean value that determines whether the user may use pinch
   * gestures to zoom in and out of the map.
   */
  imageURLString: PropTypes.string,
  markers: PropTypes.array,
  onClickAnnotation: PropTypes.func,
};

var CKReactImageMap = requireNativeComponent('CKRNImageMap', CKReactImageMapView);

module.exports = CKReactImageMapView;
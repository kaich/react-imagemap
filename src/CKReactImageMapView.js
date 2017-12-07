// CKReactImageMapView.js
import PropTypes from 'prop-types';
import React from 'react';
import { requireNativeComponent } from 'react-native';

class CKReactImageMapView extends React.Component {
  render() {
    return <CKReactImageMap {...this.props} />;
  }
}

CKReactImageMapView.propTypes = {
  /**
   * A Boolean value that determines whether the user may use pinch
   * gestures to zoom in and out of the map.
   */
  imageURLString: PropTypes.string,
  markers: PropTypes.array,
};

var CKReactImageMap = requireNativeComponent('CKRNImageMap', CKReactImageMapView);

module.exports = CKReactImageMapView;
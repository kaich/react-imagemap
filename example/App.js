/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  ActionSheetIOS
} from 'react-native';
import CKReactImageMapView from './CKReactImageMapView';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

export default class App extends Component<{}> {
  render() {
    return (
      <View style={styles.container}>
        <CKReactImageMapView 
        ref={ref => this.imageMap = ref}
        style={styles.instructions} 
        mapName="example"
        imageURLString="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1512564037530&di=c9daba6def0a23f7328d8c70085420c9&imgtype=0&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fbd315c6034a85edf2da2383043540923dd5475f3.jpg"
        markers={[
          {point: {x: 100 , y: 200}, size: {width: 20, height: 40}, title: "test", message: "message text", imageURL: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1512793642551&di=3f4454ce4d9ef58d259834aa56897f76&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Faa18972bd40735fa3981838395510fb30f240893.jpg", markedImageURL: "https://avatars0.githubusercontent.com/u/5013020?s=460&v=4" },

        ]}
        onClickAnnotation={(event) => {this._onClickAnnotation(event)}}
        />
      </View>
    );
  }

  _onClickAnnotation = (event) => {
    let marker = event.nativeEvent.marker

    ActionSheetIOS.showActionSheetWithOptions({
      options: ['mark', 'Cancel'],
      cancelButtonIndex: 1,
    },
    (buttonIndex) => {
      if (buttonIndex === 0) { 
        this.imageMap.mark(marker)
      }
    });
  }


}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    width: 320, 
    height: 400,
    backgroundColor: 'red'
  },
});

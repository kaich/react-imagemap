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
  View
} from 'react-native';
import CKReactImageMapView from '../src/CKReactImageMapView'

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
        style={styles.instructions} 
        imageURLString="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1512564037530&di=c9daba6def0a23f7328d8c70085420c9&imgtype=0&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fbd315c6034a85edf2da2383043540923dd5475f3.jpg"
        markers={[{point: {x: 100 , y: 200}, size: {width: 20, height: 40}, title: "test", message: "message text", imageURL: "https://avatars1.githubusercontent.com/u/5013020?s=88&v=4" }]} 
        />
      </View>
    );
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

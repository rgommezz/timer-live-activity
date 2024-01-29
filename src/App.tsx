import React from 'react';
import {Button, SafeAreaView, Text, View} from 'react-native';
import useTimer from './useTimer.ts';

function App(): React.JSX.Element {
  const {value, reset, play, pause, isPlaying} = useTimer();
  return (
    <SafeAreaView
      style={{flex: 1, justifyContent: 'center', alignItems: 'center'}}>
      <View style={{paddingVertical: 32}}>
        <Text style={{fontSize: 80, fontVariant: ['tabular-nums']}}>
          {value}
        </Text>
      </View>
      <View
        style={{
          flexDirection: 'row',
          justifyContent: 'space-between',
          paddingHorizontal: 48,
        }}>
        <View style={{marginRight: 32}}>
          <Button
            title={isPlaying ? 'Pause' : 'Play'}
            onPress={isPlaying ? pause : play}
          />
        </View>
        <Button title="Stop" onPress={reset} />
      </View>
    </SafeAreaView>
  );
}

export default App;

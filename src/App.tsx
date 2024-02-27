import React from 'react';
import {Text, View} from 'react-native';
import {IconButton, Provider as PaperProvider} from 'react-native-paper';
import useTimer from './useTimer.ts';

function App(): React.JSX.Element {
  const {value, reset, play, pause, isPlaying} = useTimer();
  return (
    <PaperProvider>
      <View style={{padding: 32, alignItems: 'center'}}>
        <View style={{paddingTop: 32, paddingBottom: 16}}>
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
            <IconButton
              icon={isPlaying ? 'pause' : 'play'}
              mode="contained"
              size={32}
              onPress={isPlaying ? pause : play}
            />
          </View>
          <IconButton
            icon="refresh"
            mode="contained"
            size={32}
            onPress={reset}
          />
        </View>
      </View>
    </PaperProvider>
  );
}

export default App;

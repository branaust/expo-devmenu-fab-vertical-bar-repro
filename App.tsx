import { StatusBar } from 'expo-status-bar';
import { useState } from 'react';
import { Button, StyleSheet, Text, View } from 'react-native';
import { requireOptionalNativeModule } from 'expo';

import { presentProbe } from './modules/vertical-bar-probe';

// The dev menu's own preferences module; used here only as a shortcut for the
// "Show floating action button" setting in the dev menu.
const DevMenuPreferences = requireOptionalNativeModule<{
  getPreferencesAsync(): Promise<{ showFloatingActionButton: boolean }>;
  setPreferencesAsync(settings: { showFloatingActionButton: boolean }): Promise<void>;
}>('DevMenuPreferences');

export default function App() {
  const [fabShown, setFabShown] = useState<boolean | null>(null);

  const toggleFab = async () => {
    if (!DevMenuPreferences) return;
    const { showFloatingActionButton } = await DevMenuPreferences.getPreferencesAsync();
    await DevMenuPreferences.setPreferencesAsync({
      showFloatingActionButton: !showFloatingActionButton,
    });
    setFabShown(!showFloatingActionButton);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.text}>
        Run on the iPhone Duo outer display (iOS 27.1). The presented screen
        returns preferredVerticalBarBehavior = .disabled.
      </Text>
      <Button title="Present opted-out screen" onPress={() => presentProbe(true)} />
      <Button title="Present default screen" onPress={() => presentProbe(false)} />
      <Button
        title={`Toggle dev menu floating button${fabShown === null ? '' : fabShown ? ' (shown)' : ' (hidden)'}`}
        onPress={toggleFab}
      />
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    gap: 12,
    padding: 24,
    backgroundColor: '#fff',
    justifyContent: 'center',
  },
  text: {
    textAlign: 'center',
  },
});

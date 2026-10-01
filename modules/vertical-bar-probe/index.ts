import { requireNativeModule } from 'expo';

const VerticalBarProbe = requireNativeModule<{
  present(disabled: boolean): Promise<void>;
}>('VerticalBarProbe');

export function presentProbe(disabled: boolean) {
  return VerticalBarProbe.present(disabled);
}

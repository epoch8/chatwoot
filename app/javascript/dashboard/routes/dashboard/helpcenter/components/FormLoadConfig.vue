<template>
  <form
      class="form-load-config"
      @submit.prevent="submit"
  >
    <div class="form-load-config__content">
      <label
          :class="{'form-load-config__label--active-drag': dragActive}"
          class="form-load-config__label">
        <input
            class="form-load-config__input"
            type="file"
            :placeholder="$t('HELP_CENTER.FORM_SEARCH.PLACEHOLDER_TITLE_INPUT')"
            @dragenter.prevent="dragStart"
            @dragleave.prevent="dragEnd"
            @drop="dropFile"
            @change="changeFile"
        />
        <p v-if="file === null" class="form-load-config__input-description">
          {{ $t('HELP_CENTER.LOAD_CONFIG_FORM.DISCLAIMER_FILE') }}
        </p>
        <p v-if="file !== null" class="form-load-config__input-description">
          {{ $t('HELP_CENTER.LOAD_CONFIG_FORM.DISCLAIMER_SELECTED_FILE') }}
          <span class="form-load-config__input-file-name">
          {{ fileName }}
          </span>
        </p>
      </label>
      <div
          v-if="!$v.file.required && $v.file.$dirty"
          class="form-load-config__error">
        {{ $t('HELP_CENTER.LOAD_CONFIG_FORM.ERROR_REQUIRE') }}
      </div>
      <div
          v-else-if="!$v.file.validFormat && $v.file.$dirty"
          class="form-load-config__error">
        {{ $t('HELP_CENTER.LOAD_CONFIG_FORM.ERROR_FORMAT_FILE') }}
      </div>
    </div>
    <div class="form-load-config__footer">
      <woot-submit-button
          class="form-load-config__submit"
          :button-text="$t('HELP_CENTER.LOAD_CONFIG_FORM.LOAD_BUTTON')"
          type="submit"
          :loading="isLoading"
          :disabled="isLoading || file === null"
      />
    </div>
  </form>
</template>

<script>
import { required } from 'vuelidate/lib/validators';

const validFormat = (value) => {
  let returnValue = false;
  if (value && typeof value === 'object') {
    returnValue = (/json|csv|ms-excel|spreadsheetml\.sheet/).test(value.type);
  }

  return returnValue;
};
export default {
  name: "FormLoadConfig",
  props: {
    isLoading: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      file: null,
      dragActive: false,
    };
  },
  validations: {
    file: {
      required,
      validFormat,
    },
  },
  computed: {
    fileName() {
      let returnValue = null;
      if (typeof this.file === 'object') {
        returnValue = this.file.name;
      }
      return returnValue;
    },
  },
  methods: {
    dragStart() {
      this.dragActive = true;
    },
    dragEnd() {
      this.dragActive = false;
    },
    dropFile(e) {
      this.dragEnd();
      const files = e.target.files || e.dataTransfer.files;
      this.file = files[0];
      this.$v.file.$touch();
    },
    changeFile(e) {
      const files = e.target.files || e.dataTransfer.files;
      if (!files.length) {
        this.file = null;
        return;
      }
      this.file = files[0];
      this.$v.file.$touch();
    },
    submit() {
      this.$v.$touch();
      if (this.$v.$invalid) {
        return;
      }
      this.$emit('submit', this.file);
    },
  },
}
</script>

<style lang="scss" scoped>
$b: '.form-load-config';

#{$b} {
  &__content {
    padding-top: 30px;
    padding-bottom: 30px;
  }

  &__footer {
    display: flex;
    justify-content: center;
    align-items: center;
  }

  &__label {
    padding: 64px 24px;
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    border: 3px dotted var(--s-700);
    border-radius: 8px;

    &--active-drag {
      border-color: var(--w-500);
      background-color: var(--w-100);
    }
  }

  &__input {
    position: absolute;
    width: 100%;
    height: 100%;
    left: 0;
    top: 0;
    opacity: 0;
  }

  &__input-description {
    color: var(--s-700);
    font-size: 14px;
    line-height: 1.2;
    text-align: center;
  }

  &__input-file-name {
    color: var(--w-500);
  }

  &__error {
    color: var(--r-400);
    font-size: var(--font-size-small);
    font-weight: var(--font-weight-normal);
    margin-top: 8px;
  }
}
</style>

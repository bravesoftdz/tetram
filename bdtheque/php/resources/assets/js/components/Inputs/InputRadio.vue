<template>
    <label>
        <input type="radio" :checked="shouldBeChecked" :value="value" @change="updateInput">
        {{ label }}
    </label>
</template>
<script>
    export default {
        name: "InputRadio",
        model: {
            prop: 'modelValue',
            event: 'change'
        },
        props: {
            value: {
                type: String,
            },
            modelValue: {
                default: ""
            },
            label: {
                type: String,
                required: true
            },
        },
        computed: {
            shouldBeChecked() {
                return this.modelValue === this.value;
            }
        },
        methods: {
            updateInput() {
                this.$emit('change', this.value);
            }
        }
    }
</script>

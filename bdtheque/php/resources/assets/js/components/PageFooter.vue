<template>
    <v-footer :fixed="fixed" app>
        <span>&copy; {{ new Date().getFullYear() }}</span>
    </v-footer>
</template>

<script>
    export default {
        data() {
            return {
                fixed: false
            }
        }
    }
</script>

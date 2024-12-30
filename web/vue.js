import colorConfig from './vue.config.js'

const rent = new Vue({
    el: "#app",
    data: {
        ui: {
            active: false,

            carData: null
        },
        prompt: {
            active: false,

            paymentMethod: null,

            vehicle: {
                price: 100,
                spawnCode: null
            },

            activeColor: null,
            
            colors: colorConfig['prompt']['colors']
        }
    },
    mounted() {
        window['addEventListener']("keydown", this.onKey)
        window['addEventListener']("message", this.onMessage)
    },
    methods: {
        async post(url, data = {}) {
            try {
                const response = await fetch(`https://${GetParentResourceName()}/${url}`, {
                    method: "POST",
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                });

                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }

                return await response.json();
            } catch (error) {
                throw error;
            }
        },

        onKey() {
            const theKey = event.code

            if (theKey == "Escape" && this['ui']['active']) {
                this['destroy']()
            }
        },

        onMessage() {
            const data = event['data'];

            if (data['act'] === "interface") {
                switch (data['event']) {
                    case 'build':
                        this['ui']['active'] = true; this['prompt']['paymentMethod'] = 'cash'; this['prompt']['activeColor'] = '#0d1116'

                        this['ui']['carData'] = data['config']
                        break
                    
                    default:
                        break
                }
            }
        },

        build() {
            this['ui']['active'] = true;

            this['post']('nuiFocus', true);
        },        

        selectMethod(type) {
            this['prompt']['paymentMethod'] = type
        },

        selectColor(color) {
            this['prompt']['activeColor'] = color
        },

        showPrompt(data) {
            this['prompt']['active'] = true

            this['prompt']['vehicle'] = {
                ['vehicleName']: data['carName'],
                ['price']: data['carPrice'],
                ['spawnCode']: data['spawnCode']
            }
        },

        closePrompt() {
            this['prompt']['active'] = false
        },

        confirmPrompt(type, price) {
            switch(type) {
                case 'buyCar':
                    this['post']('rentCar', {
                        vehicle: this['prompt']['vehicle']['spawnCode'],
                        price: this['prompt']['vehicle']['price'],
                        color: this['prompt']['activeColor'],
                        paymentMethod: this['prompt']['paymentMethod'],
                    })
                break

                default:
                    break
            }

            this['destroy']()
        },

        destroy() {
            this['ui']['active'] = false; this['prompt']['active'] = false; this['prompt']['paymentMethod'] = null; this['prompt']['activeColor'] = null

            this['post']('nuiFocus', false);
        }
    }
})
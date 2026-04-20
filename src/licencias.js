import { initializeApp } from 'firebase/app'
import { getFirestore, doc, getDoc, updateDoc } from 'firebase/firestore'

const firebaseConfig = {
    apiKey: "AIzaSyCmQk0ILZBfQPWa9dTikwPtl9eWCQFzFQA",
    authDomain: "bot-whatsapp-licencias.firebaseapp.com",
    projectId: "bot-whatsapp-licencias",
    storageBucket: "bot-whatsapp-licencias.firebasestorage.app",
    messagingSenderId: "1063082541712",
    appId: "1:1063082541712:web:35cb273de8693d430e4e15"
}

const app = initializeApp(firebaseConfig)
const db = getFirestore(app)

export async function verificarLicencia(codigo) {
    try {
        const docRef = doc(db, 'licencias', codigo)
        const docSnap = await getDoc(docRef)
        if (!docSnap.exists()) return { valida: false, motivo: 'Licencia no encontrada' }

        const datos = docSnap.data()
        const ahora = new Date()
        const vencimiento = datos.vencimiento.toDate()

        if (!datos.activa) return { valida: false, motivo: 'Licencia desactivada' }
        if (ahora > vencimiento) return { valida: false, motivo: 'Licencia vencida' }

        return {
            valida: true,
            negocio: datos.negocio,
            tipo: datos.tipo,
            vencimiento: vencimiento.toLocaleDateString('es-MX')
        }
    } catch (e) {
        console.log('Error verificando licencia:', e.message)
        return { valida: false, motivo: 'Error de conexion' }
    }
}

export async function activarLicencia(codigo, numeroWhatsapp) {
    try {
        const docRef = doc(db, 'licencias', codigo)
        const docSnap = await getDoc(docRef)
        if (!docSnap.exists()) return { valida: false, motivo: 'Licencia no encontrada' }

        const datos = docSnap.data()
        const ahora = new Date()
        const vencimiento = datos.vencimiento.toDate()

        if (!datos.activa) return { valida: false, motivo: 'Licencia desactivada' }
        if (ahora > vencimiento) return { valida: false, motivo: 'Licencia vencida' }

        if (datos.numeroWhatsapp && datos.numeroWhatsapp !== numeroWhatsapp) {
            return { valida: false, motivo: 'Esta licencia ya esta en uso por otro numero de WhatsApp' }
        }

        if (!datos.numeroWhatsapp) {
            await updateDoc(docRef, { numeroWhatsapp })
        }

        return {
            valida: true,
            negocio: datos.negocio,
            tipo: datos.tipo,
            vencimiento: vencimiento.toLocaleDateString('es-MX')
        }
    } catch (e) {
        console.log('Error activando licencia:', e.message)
        return { valida: false, motivo: 'Error de conexion' }
    }
}
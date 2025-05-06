object luke {
  var cantidadViajes = 0
  var recuerdo = null
  var vehiculo = alambiqueVeloz
  
  method cantidadViajes() = cantidadViajes
  
  method viajar(lugar) {
    if (lugar.puedeLlegar(vehiculo)) {
      cantidadViajes += 1
      recuerdo = lugar.recuerdoTipico()
      vehiculo.desgaste()
    }
  }
  
  method recuerdo() = recuerdo
  
  method vehiculo(nuevo) {
    vehiculo = nuevo
  }
} 

//Ciudades
object paris {
  method recuerdoTipico() = "Llavero Torre Eiffel"
  
  method puedeLlegar(movil) = movil.puedeFuncionar()
}

object buenosAires {
  method recuerdoTipico() = "Mate"
  
  method puedeLlegar(auto) = auto.rapido()
}

object bagdad {
  var recuerdo = "bidon de petroleo"
  
  method recuerdoTipico() = recuerdo
  
  method recuerdo(nuevo) {
    recuerdo = nuevo
  }
  
  method puedeLlegar(cualquierCosa) = true
}

object lasVegas {
  var homenaje = paris
  
  method homenaje(lugar) {
    homenaje = lugar
  }
  
  method recuerdoTipico() = homenaje.recuerdoTipico()
  
  method puedeLlegar(vehiculo) = homenaje.puedeLlegar(vehiculo)
}

object hurlingham {
  method puedeLlegar(
    vehiculo
  ) = (vehiculo.puedeFuncionar() and vehiculo.rapido()) and vehiculo.patenteValida()
  
  method recuerdoTipico() = "sticker de la Unahur"
} 

//Vehiculos
object alambiqueVeloz {
  const rapido = true
  var combustible = 20
  const consumoPorViaje = 10
  const patente = "AB123JK"
  
  method puedeFuncionar() = combustible >= consumoPorViaje
  
  method desgaste() {
    combustible -= consumoPorViaje
  }
  
  method rapido() = rapido
  
  method patenteValida() = patente  == "AB123JK"
  
  method inscribirseACarrera() {
    centroDeInscripcion.recibirInscripcion(self)
  }
  
  method viajarA(unaCiudad) {
    if (unaCiudad.puedeLlegar(self)) self.desgaste()
  }
}

object antigualla {
  var gangsters = 7
  
  method puedeFuncionar() = gangsters.even()
  
  method rapido() = gangsters > 6
  
  method desgaste() {
    gangsters -= 1
  }
  
  method patenteValida() = chatarra.rapido()
  
  method inscribirseACarrera() {
    centroDeInscripcion.recibirInscripcion(self)
  }
  
  method viajarA(unaCiudad) {
    if (unaCiudad.puedeLlegar(self)) self.desgaste()
  }
}

object chatarra {
  var caniones = 10
  var municiones = "ACME"
  
  method puedeFuncionar() = (municiones == "ACME") and caniones.between(6, 12)
  
  method rapido() = municiones.size() < caniones
  
  method desgaste() {
    caniones = (caniones / 2).roundUp(0)
    if (caniones < 5) {
      municiones += " Obsoleto"
    }
  }
  
  method patenteValida() = municiones.take(4) == "ACME"
  
  method caniones() = caniones
  
  method inscribirseACarrera() {
    centroDeInscripcion.recibirInscripcion(self)
  }
  
  method viajarA(unaCiudad) {
    if (unaCiudad.puedeLlegar(self)) self.desgaste()
  }
}

object convertible {
  var convertido = antigualla
  
  method puedeFuncionar() = convertido.puedeFuncionar()
  
  method rapido() = convertido.rapido()
  
  method desgaste() {
    convertido.desgaste()
  }
  
  method convertir(vehiculo) {
    convertido = vehiculo
  }
  
  method inscribirseACarrera() {
    centroDeInscripcion.recibirInscripcion(self)
  }
  
  method patenteValida() = convertido.patenteValida()
  
  method viajarA(unaCiudad) {
    if (unaCiudad.puedeLlegar(self)) self.desgaste()
  }
}

object moto {
  method rapido() = true
  
  method puedeFuncionar() = not self.rapido()
  
  method desgaste() {
    
  }
  
  method patenteValida() = false
  
  method inscribirseACarrera() {
    centroDeInscripcion.recibirInscripcion(self)
  }
  
  method viajarA(unaCiudad) {
    if (unaCiudad.puedeLlegar(self)) self.desgaste()
  }
}

//Otros
object centroDeInscripcion {
  var ciudadDelAcontecimiento = buenosAires
  const inscriptos = #{}
  const aceptados = #{}
  const rechazados = #{}
  
  method recibirInscripcion(vehiculo) {
    inscriptos.add(vehiculo)
    self.verificarVehiculo(vehiculo)
  }
  
  method verificarVehiculo(vehiculo) {
    if (ciudadDelAcontecimiento.puedeLlegar(vehiculo)) aceptados.add(vehiculo)
    else rechazados.add(vehiculo)
  }
  
  method ciudadDelAcontecimiento(unaCiudad) {
    ciudadDelAcontecimiento = unaCiudad
  }
  
  method ciudadDelAcontecimiento() = ciudadDelAcontecimiento
  
  method replanificarEvento(unaCiudad) {
    self.ciudadDelAcontecimiento(unaCiudad)
    inscriptos.forEach({ v => self.verificarVehiculo(v) })
  }
  
  method aceptados() = aceptados
}

object carrera {
  method ciudad() = centroDeInscripcion.ciudadDelAcontecimiento()
  
  method participantes() = centroDeInscripcion.aceptados()
  
  method comenzarYDecirGanador() {
    self.avisarAVehiculos()
    return self.participantes().anyOne()
  }
  
  /*method separarVehiculosRapidos() {
    const corredores = []
    if (self.participantes().forEach({ p => p.rapido() })) corredores.add(
        self.participantes().forEach({ p => p.rapido() })
      )
    return corredores
  }*/
  
  method avisarAVehiculos() {
    self.participantes().forEach({ v => v.viajarA(self.ciudad()) })
  }
}
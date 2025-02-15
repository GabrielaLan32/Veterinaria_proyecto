/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Clases;

/**
 *
 * @author Usuario
 */
public class CitasAgendadas {
    private int idCita;
    private String motivo;
    private String fecha; // Puedes usar java.util.Date o java.time.LocalDate
    private int idHorario;
    private int idMascota;
    private int idVeterinario;

    // Constructor
    public CitasAgendadas(int idCita, String motivo, String fecha, int idHorario, int idMascota, int idVeterinario) {
        this.idCita = idCita;
        this.motivo = motivo;
        this.fecha = fecha;
        this.idHorario = idHorario;
        this.idMascota = idMascota;
        this.idVeterinario = idVeterinario;
    }

    // Getters y Setters
    public int getIdCita() {
        return idCita;
    }

    public void setIdCita(int idCita) {
        this.idCita = idCita;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public int getIdHorario() {
        return idHorario;
    }

    public void setIdHorario(int idHorario) {
        this.idHorario = idHorario;
    }

    public int getIdMascota() {
        return idMascota;
    }

    public void setIdMascota(int idMascota) {
        this.idMascota = idMascota;
    }

    public int getIdVeterinario() {
        return idVeterinario;
    }

    public void setIdVeterinario(int idVeterinario) {
        this.idVeterinario = idVeterinario;
    }
}

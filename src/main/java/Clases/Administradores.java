/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Clases;

/**
 *
 * @author Usuario
 */
public class Administradores {
    private int idAdmin;
    private String nCedula;

    // Constructor
    public Administradores(int idAdmin, String nCedula) {
        this.idAdmin = idAdmin;
        this.nCedula = nCedula;
    }

    // Getters y Setters
    public int getIdAdmin() {
        return idAdmin;
    }

    public void setIdAdmin(int idAdmin) {
        this.idAdmin = idAdmin;
    }

    public String getnCedula() {
        return nCedula;
    }

    public void setnCedula(String nCedula) {
        this.nCedula = nCedula;
    }
}

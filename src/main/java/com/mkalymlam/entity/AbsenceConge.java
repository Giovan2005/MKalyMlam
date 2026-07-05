package com.mkalymlam.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "\"absenceConge\"")
@Data
public class AbsenceConge {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "\"idAbsence\"")
    private Integer idAbsence;

    @Column(name = "\"idUtilisateur\"", nullable = false)
    private Integer idUtilisateur;

    @Column(name = "\"idTypeConge\"", nullable = false)
    private Integer idTypeConge;

    @Column(name = "\"dateDebut\"", nullable = false)
    private LocalDate dateDebut;

    @Column(name = "\"dateFin\"", nullable = false)
    private LocalDate dateFin;

    @Column(name = "\"idStatutValidation\"", nullable = false)
    private Integer idStatutValidation;

    @Column(name = "\"deductionSalaireAppliquee\"")
    private BigDecimal deductionSalaireAppliquee = BigDecimal.ZERO;

    @Column(name = "\"idRemplacant\"")
    private Integer idRemplacant;
}
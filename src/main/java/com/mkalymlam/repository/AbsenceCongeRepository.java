package com.mkalymlam.repository;

import com.mkalymlam.entity.AbsenceConge;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AbsenceCongeRepository extends JpaRepository<AbsenceConge, Integer> {
    List<AbsenceConge> findAllByOrderByIdAbsenceDesc();
}
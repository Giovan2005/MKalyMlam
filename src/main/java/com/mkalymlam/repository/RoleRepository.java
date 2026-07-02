package com.mkalymlam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mkalymlam.entity.Role;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {

    Role findByLibelle(String libelle);
}

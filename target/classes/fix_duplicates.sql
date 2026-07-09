-- ==============================================================================
-- Correctif: Suppression des doublons et ajout de contraintes UNIQUE
-- ==============================================================================

-- 1. Supprimer les doublons dans "role" (garder le plus petit id)
DELETE FROM "role" r1 USING "role" r2
WHERE r1."idRole" > r2."idRole" AND r1."libelle" = r2."libelle";

-- 2. Supprimer les doublons dans "statutDisponibilite"
DELETE FROM "statutDisponibilite" s1 USING "statutDisponibilite" s2
WHERE s1."idStatutDisponibilite" > s2."idStatutDisponibilite" AND s1."libelle" = s2."libelle";

-- 3. Supprimer les doublons dans "statutSession"
DELETE FROM "statutSession" s1 USING "statutSession" s2
WHERE s1."idStatutSession" > s2."idStatutSession" AND s1."libelle" = s2."libelle";

-- 4. Supprimer les doublons dans les autres tables de référence
DELETE FROM "typeConge" t1 USING "typeConge" t2
WHERE t1."idTypeConge" > t2."idTypeConge" AND t1."libelle" = t2."libelle";

DELETE FROM "statutValidation" s1 USING "statutValidation" s2
WHERE s1."idStatutValidation" > s2."idStatutValidation" AND s1."libelle" = s2."libelle";

DELETE FROM "typeEquipement" t1 USING "typeEquipement" t2
WHERE t1."idTypeEquipement" > t2."idTypeEquipement" AND t1."libelle" = t2."libelle";

DELETE FROM "statutAlerte" s1 USING "statutAlerte" s2
WHERE s1."idStatutAlerte" > s2."idStatutAlerte" AND s1."libelle" = s2."libelle";

DELETE FROM "methodeComptable" m1 USING "methodeComptable" m2
WHERE m1."idMethodeComptable" > m2."idMethodeComptable" AND m1."libelle" = m2."libelle";

DELETE FROM "typeItem" t1 USING "typeItem" t2
WHERE t1."idTypeItem" > t2."idTypeItem" AND t1."libelle" = t2."libelle";

DELETE FROM "typeCommande" t1 USING "typeCommande" t2
WHERE t1."idTypeCommande" > t2."idTypeCommande" AND t1."libelle" = t2."libelle";

DELETE FROM "statutCommande" s1 USING "statutCommande" s2
WHERE s1."idStatutCommande" > s2."idStatutCommande" AND s1."libelle" = s2."libelle";

DELETE FROM "typeTarification" t1 USING "typeTarification" t2
WHERE t1."idTypeTarification" > t2."idTypeTarification" AND t1."libelle" = t2."libelle";

DELETE FROM "actionCommande" a1 USING "actionCommande" a2
WHERE a1."idActionCommande" > a2."idActionCommande" AND a1."libelle" = a2."libelle";

DELETE FROM "modePaiement" m1 USING "modePaiement" m2
WHERE m1."idModePaiement" > m2."idModePaiement" AND m1."libelle" = m2."libelle";

DELETE FROM "typeDepense" t1 USING "typeDepense" t2
WHERE t1."idTypeDepense" > t2."idTypeDepense" AND t1."libelle" = t2."libelle";

DELETE FROM "statutValidationAdmin" s1 USING "statutValidationAdmin" s2
WHERE s1."idStatutValidationAdmin" > s2."idStatutValidationAdmin" AND s1."libelle" = s2."libelle";

DELETE FROM "typeRetour" t1 USING "typeRetour" t2
WHERE t1."idTypeRetour" > t2."idTypeRetour" AND t1."libelle" = t2."libelle";

DELETE FROM "classificationSentiment" c1 USING "classificationSentiment" c2
WHERE c1."idClassificationSentiment" > c2."idClassificationSentiment" AND c1."libelle" = c2."libelle";

DELETE FROM "statutDemandeAchat" s1 USING "statutDemandeAchat" s2
WHERE s1."idStatutDemandeAchat" > s2."idStatutDemandeAchat" AND s1."libelle" = s2."libelle";

DELETE FROM "typeNotification" t1 USING "typeNotification" t2
WHERE t1."idTypeNotification" > t2."idTypeNotification" AND t1."libelle" = t2."libelle";

-- 5. Ajouter les contraintes UNIQUE sur "libelle"
ALTER TABLE "role" ADD CONSTRAINT "uq_role_libelle" UNIQUE ("libelle");
ALTER TABLE "statutDisponibilite" ADD CONSTRAINT "uq_statutDisponibilite_libelle" UNIQUE ("libelle");
ALTER TABLE "statutSession" ADD CONSTRAINT "uq_statutSession_libelle" UNIQUE ("libelle");
ALTER TABLE "typeConge" ADD CONSTRAINT "uq_typeConge_libelle" UNIQUE ("libelle");
ALTER TABLE "statutValidation" ADD CONSTRAINT "uq_statutValidation_libelle" UNIQUE ("libelle");
ALTER TABLE "typeEquipement" ADD CONSTRAINT "uq_typeEquipement_libelle" UNIQUE ("libelle");
ALTER TABLE "statutAlerte" ADD CONSTRAINT "uq_statutAlerte_libelle" UNIQUE ("libelle");
ALTER TABLE "methodeComptable" ADD CONSTRAINT "uq_methodeComptable_libelle" UNIQUE ("libelle");
ALTER TABLE "typeItem" ADD CONSTRAINT "uq_typeItem_libelle" UNIQUE ("libelle");
ALTER TABLE "typeCommande" ADD CONSTRAINT "uq_typeCommande_libelle" UNIQUE ("libelle");
ALTER TABLE "statutCommande" ADD CONSTRAINT "uq_statutCommande_libelle" UNIQUE ("libelle");
ALTER TABLE "typeTarification" ADD CONSTRAINT "uq_typeTarification_libelle" UNIQUE ("libelle");
ALTER TABLE "actionCommande" ADD CONSTRAINT "uq_actionCommande_libelle" UNIQUE ("libelle");
ALTER TABLE "modePaiement" ADD CONSTRAINT "uq_modePaiement_libelle" UNIQUE ("libelle");
ALTER TABLE "typeDepense" ADD CONSTRAINT "uq_typeDepense_libelle" UNIQUE ("libelle");
ALTER TABLE "statutValidationAdmin" ADD CONSTRAINT "uq_statutValidationAdmin_libelle" UNIQUE ("libelle");
ALTER TABLE "typeRetour" ADD CONSTRAINT "uq_typeRetour_libelle" UNIQUE ("libelle");
ALTER TABLE "classificationSentiment" ADD CONSTRAINT "uq_classificationSentiment_libelle" UNIQUE ("libelle");
ALTER TABLE "statutDemandeAchat" ADD CONSTRAINT "uq_statutDemandeAchat_libelle" UNIQUE ("libelle");
ALTER TABLE "typeNotification" ADD CONSTRAINT "uq_typeNotification_libelle" UNIQUE ("libelle");

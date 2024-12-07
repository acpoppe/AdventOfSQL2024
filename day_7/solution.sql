/*
 * Santa's workshop is implementing a new mentoring program! He noticed that some
 * elves excel at certain tasks but could benefit from working with others who
 * share the same skills. To make the workshop more efficient, Santa needs to
 * pair up elves who have the same skills so they can collaborate and learn from
 * each other. However, he wants to make sure each pair is only listed once
 * (no duplicates where Elf1/Elf2 are reversed) and that elves aren't paired
 * with themselves.
 *
 * Create a query that returns pairs of elves who share the same primary_skill.
 * The pairs should be comprised of the elf with the most (max) and least (min)
 * years of experience in the primary_skill.
 *
 * When you have multiple elves with the same years_experience, order the elves
 * by elf_id in ascending order.
 *
 * Your query should return:
 * 1. The ID of the first elf with the Max years experience
 * 2. The ID of the first elf with the Min years experience
 * 3. Their shared skill
 *
 * Notes:
 * 1. Each pair should be returned only once.
 * 2. Elves can not be paired with themselves, a primary_skill will always have
 *    more than 1 elf.
 * 3. Order by primary_skill, there should only be one row per primary_skill.
 * 4. In case of duplicates order first by elf_1_id, then elf_2_id.
 *
 * In the inputs below provide one row per primary_skill in the format, with
 * no spaces and comma separation:
 * `max_years_experience_elf_id,min_years_experience_elf_id,shared_skill`
 *
 * Do not use any special characters such as " or ' in your answer.
 */

WITH m_xp_tm AS
         (SELECT *, ROW_NUMBER() OVER (ORDER BY years_experience DESC, elf_id) AS match_number
          FROM workshop_elves
          WHERE primary_skill = 'Toy making'
          ORDER BY years_experience DESC, elf_id
          LIMIT (SELECT COUNT(*) / 2 FROM workshop_elves WHERE primary_skill = 'Toy making')),
     l_xp_tm AS
         (SELECT *, ROW_NUMBER() OVER (ORDER BY years_experience, elf_id) AS match_number
          FROM workshop_elves
          WHERE primary_skill = 'Toy making'
          ORDER BY years_experience, elf_id
          LIMIT (SELECT COUNT(*) / 2 FROM workshop_elves WHERE primary_skill = 'Toy making')),
     xp_tm AS
         (SELECT m.elf_id AS max_years_experience_elf_id,
                 l.elf_id AS min_years_experience_elf_id,
                 m.primary_skill AS shared_skill
          FROM m_xp_tm m
                   FULL JOIN l_xp_tm l
                             ON m.match_number = l.match_number
          LIMIT 1),

     m_xp_gw AS
         (SELECT *, ROW_NUMBER() OVER (ORDER BY years_experience DESC, elf_id) AS match_number
          FROM workshop_elves
          WHERE primary_skill = 'Gift wrapping'
          ORDER BY years_experience DESC, elf_id
          LIMIT (SELECT COUNT(*) / 2 FROM workshop_elves WHERE primary_skill = 'Gift wrapping')),
     l_xp_gw AS
         (SELECT *, ROW_NUMBER() OVER (ORDER BY years_experience, elf_id) AS match_number
          FROM workshop_elves
          WHERE primary_skill = 'Gift wrapping'
          ORDER BY years_experience, elf_id
          LIMIT (SELECT COUNT(*) / 2 FROM workshop_elves WHERE primary_skill = 'Gift wrapping')),
     xp_gw AS
         (SELECT m.elf_id AS max_years_experience_elf_id,
                 l.elf_id AS min_years_experience_elf_id,
                 m.primary_skill AS shared_skill
          FROM m_xp_gw m
                   FULL JOIN l_xp_gw l
                             ON m.match_number = l.match_number
          LIMIT 1),

     m_xp_gs AS
         (SELECT *, ROW_NUMBER() OVER (ORDER BY years_experience DESC, elf_id) AS match_number
          FROM workshop_elves
          WHERE primary_skill = 'Gift sorting'
          ORDER BY years_experience DESC, elf_id
          LIMIT (SELECT COUNT(*) / 2 FROM workshop_elves WHERE primary_skill = 'Gift sorting')),
     l_xp_gs AS
         (SELECT *, ROW_NUMBER() OVER (ORDER BY years_experience, elf_id) AS match_number
          FROM workshop_elves
          WHERE primary_skill = 'Gift sorting'
          ORDER BY years_experience, elf_id
          LIMIT (SELECT COUNT(*) / 2 FROM workshop_elves WHERE primary_skill = 'Gift sorting')),
     xp_gs AS
         (SELECT m.elf_id AS max_years_experience_elf_id,
                 l.elf_id AS min_years_experience_elf_id,
                 m.primary_skill AS shared_skill
          FROM m_xp_gs m
                   FULL JOIN l_xp_gs l
                             ON m.match_number = l.match_number
          LIMIT 1)



SELECT *
FROM xp_tm
UNION
SELECT *
FROM xp_gw
UNION
SELECT *
FROM xp_gs
ORDER BY shared_skill;

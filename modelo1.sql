--essa consulta retorna a qtd de casos que passam nesse filtro, estando apenas awaiting_analysis

SELECT
  COUNT(*)
FROM `st_mongo_backoffice_underwriting.proposal_activity` AS pa
WHERE
  -- Condição 1: Verifica se o status mais recente é 'awaiting_analysis'
  (SELECT data.status FROM UNNEST(pa.activities) AS activity ORDER BY activity.created_at DESC LIMIT 1) = 'awaiting_analysis'
  -- Condição 2: Verifica se nenhum status no histórico está na lista de exclusão
  AND NOT EXISTS (
    SELECT 1
    FROM UNNEST(pa.activities) AS activity
    WHERE activity.data.status IN ('refused', 'accepted', 'in_analysis', 'validated', 'awaiting_validation', 'awaiting_pendencies')
  )
  -- Condição 3: Filtra propostas criadas após a data especificada
  AND pa._created > '2025-08-25';

  --precisa reficar para trazer os dados corretos, mas parece que estamos buscando no lugar certo

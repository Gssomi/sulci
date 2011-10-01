(* DO NOT EDIT MANUALLY *)
(*  *)
(* generated by sqlgg 0.2.3-49-g30df037 on 2010-01-14T17:45Z *)

module Make (T : Sqlgg_traits.M) = struct

  let create_words db  =
    T.execute db "CREATE TABLE IF NOT EXISTS words (word1 varchar(256), word2 varchar(256), counter int)" T.no_params 

  let create_index_word1word2 db  =
    T.execute db "CREATE INDEX IF NOT EXISTS word1word2 ON words (word1, word2)" T.no_params 

  let check_pair db ~word1 ~word2 =
    let get_row stmt =
      (T.get_column_Int stmt 0)
    in
    let set_params stmt =
      let p = T.start_params stmt 2 in
      T.set_param_Text p 0 word1;
      T.set_param_Text p 1 word2;
      T.finish_params p
    in
    T.select1 db "SELECT 1 FROM words WHERE word1=@word1 AND word2=@word2 LIMIT 1" set_params get_row

  let add_pair db ~word1 ~word2 ~counter =
    let set_params stmt =
      let p = T.start_params stmt 3 in
      T.set_param_Text p 0 word1;
      T.set_param_Text p 1 word2;
      T.set_param_Int p 2 counter;
      T.finish_params p
    in
    T.execute db "INSERT INTO words (word1, word2, counter) VALUES (@word1,@word2,@counter)" set_params 

  let update_pair db ~word1 ~word2 =
    let set_params stmt =
      let p = T.start_params stmt 2 in
      T.set_param_Text p 0 word1;
      T.set_param_Text p 1 word2;
      T.finish_params p
    in
    T.execute db "UPDATE words SET counter=counter+1 WHERE word1=@word1 AND word2=@word2" set_params 

  let get_sum db ~word1 =
    let get_row stmt =
      (T.get_column_Int stmt 0)
    in
    let set_params stmt =
      let p = T.start_params stmt 1 in
      T.set_param_Text p 0 word1;
      T.finish_params p
    in
    T.select1 db "SELECT coalesce(sum(counter),0) FROM words WHERE word1=@word1 LIMIT 1" set_params get_row

  let get_pair db ~word1 callback =
    let invoke_callback stmt =
      callback
        (T.get_column_Text stmt 0)
        (T.get_column_Int stmt 1)
    in
    let set_params stmt =
      let p = T.start_params stmt 1 in
      T.set_param_Text p 0 word1;
      T.finish_params p
    in
    T.select db "SELECT word2, counter FROM words WHERE word1=@word1" set_params invoke_callback

  let count db  =
    let get_row stmt =
      (T.get_column_Int stmt 0)
    in
    T.select1 db "SELECT COUNT(*) FROM words" T.no_params get_row

  let get_top db  callback =
    let invoke_callback stmt =
      callback
        (T.get_column_Text stmt 0)
        (T.get_column_Text stmt 1)
        (T.get_column_Int stmt 2)
    in
    T.select db "SELECT word1, word2, counter FROM words WHERE word1!='' AND word2!='' ORDER BY counter DESC LIMIT 10" T.no_params invoke_callback

  module Fold = struct
    let create_words db  =
      T.execute db "CREATE TABLE IF NOT EXISTS words (word1 varchar(256), word2 varchar(256), counter int)" T.no_params 

    let create_index_word1word2 db  =
      T.execute db "CREATE INDEX IF NOT EXISTS word1word2 ON words (word1, word2)" T.no_params 

    let check_pair db ~word1 ~word2 =
      let get_row stmt =
        (T.get_column_Int stmt 0)
      in
      let set_params stmt =
        let p = T.start_params stmt 2 in
        T.set_param_Text p 0 word1;
        T.set_param_Text p 1 word2;
        T.finish_params p
      in
      T.select1 db "SELECT 1 FROM words WHERE word1=@word1 AND word2=@word2 LIMIT 1" set_params get_row

    let add_pair db ~word1 ~word2 ~counter =
      let set_params stmt =
        let p = T.start_params stmt 3 in
        T.set_param_Text p 0 word1;
        T.set_param_Text p 1 word2;
        T.set_param_Int p 2 counter;
        T.finish_params p
      in
      T.execute db "INSERT INTO words (word1, word2, counter) VALUES (@word1,@word2,@counter)" set_params 

    let update_pair db ~word1 ~word2 =
      let set_params stmt =
        let p = T.start_params stmt 2 in
        T.set_param_Text p 0 word1;
        T.set_param_Text p 1 word2;
        T.finish_params p
      in
      T.execute db "UPDATE words SET counter=counter+1 WHERE word1=@word1 AND word2=@word2" set_params 

    let get_sum db ~word1 =
      let get_row stmt =
        (T.get_column_Int stmt 0)
      in
      let set_params stmt =
        let p = T.start_params stmt 1 in
        T.set_param_Text p 0 word1;
        T.finish_params p
      in
      T.select1 db "SELECT coalesce(sum(counter),0) FROM words WHERE word1=@word1 LIMIT 1" set_params get_row

    let get_pair db ~word1 callback acc =
      let invoke_callback stmt =
        callback
          (T.get_column_Text stmt 0)
          (T.get_column_Int stmt 1)
      in
      let set_params stmt =
        let p = T.start_params stmt 1 in
        T.set_param_Text p 0 word1;
        T.finish_params p
      in
      let r_acc = ref acc in
      T.select db "SELECT word2, counter FROM words WHERE word1=@word1" set_params (fun x -> r_acc := invoke_callback x !r_acc);
      !r_acc

    let count db  =
      let get_row stmt =
        (T.get_column_Int stmt 0)
      in
      T.select1 db "SELECT COUNT(*) FROM words" T.no_params get_row

    let get_top db  callback acc =
      let invoke_callback stmt =
        callback
          (T.get_column_Text stmt 0)
          (T.get_column_Text stmt 1)
          (T.get_column_Int stmt 2)
      in
      let r_acc = ref acc in
      T.select db "SELECT word1, word2, counter FROM words WHERE word1!='' AND word2!='' ORDER BY counter DESC LIMIT 10" T.no_params (fun x -> r_acc := invoke_callback x !r_acc);
      !r_acc

  end (* module Fold *)
end (* module Make *)
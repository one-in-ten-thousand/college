class Me::Show < BrowserAction
  get "/me" do
    users = UserQuery.new.id.desc_order

    if current_user.email != "zw963@163.com"
      users = users.id(current_user.id)
    end

    excluded_query = ChongWenBaoQuery.new.user_id(current_user.id).is_excluded(true)
    query = UniversityQuery.new.preload_chong_wen_baos(excluded_query)
    query = query.where_chong_wen_baos(excluded_query)

    pages, universities = paginate(query.id.desc_order.distinct, per_page: 50)

    html ShowPage, users: users, pages: pages, universities: universities
  end
end

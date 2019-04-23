require 'sqlite3'
require 'singleton'

class QuestionDBConnection < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end

end

class User
    attr_accessor :id, :fname, :lname

    def self.find_by_id(id)
        look_up = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM 
                users
            WHERE
                id = ?
        SQL
        return nil unless look_up.length > 0

        User.new(look_up.first)
    end

    def self.find_by_name(fname, lname)
        look_up = QuestionDBConnection.instance.execute(<<-SQL, fname, lname)
            SELECT 
                *
            FROM
                users
            WHERE
                fname = ? AND lname = ?
        SQL
        return nil unless look_up.length > 0 
                       
        look_up.map {|data| User.new(data) }
    end

    def initialize(options)
        @id    = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def authored_questions
        Question.find_by_user_id(self.id)
    end

    def authored_replies
        Reply.find_by_user_id(self.id)
    end

end

class Question
    attr_accessor :id, :title, :body, :user_id

    def self.find_by_id(id)
        look_up = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM 
                questions
            WHERE
                id = ?
        SQL
        return nil unless look_up.length > 0

        Question.new(look_up.first)
    end

    def self.find_by_title(title)
        look_up = QuestionDBConnection.instance.execute(<<-SQL, title)
            SELECT 
                *
            FROM
                questions
            WHERE
                title = ?
        SQL
        return nil unless look_up.length > 0 
                       
        look_up.map {|data| Question.new(data) }
    end

    def self.find_by_user_id(author_id)
        look_up = QuestionDBConnection.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                questions 
            WHERE
                user_id = ?
        SQL
        return nil unless look_up.length > 0 

        look_up.map {|data| Question.new(data)}
    end


    def initialize(options)
        @id    = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end

    def author
        User.find_by_id(user_id)
    end

    def replies
        Reply.find_by_question_id(self.id)
    end

end

class Question_follow
    attr_accessor :id, :user_id, :question_id

    def self.find_by_id(id)
        look_up = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM 
                question_follows
            WHERE
                id = ?
        SQL
        return nil unless look_up.length > 0

        Question_follow.new(look_up.first)
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

end

class Reply   # PARENT REPLY ID IS MISSING  WHY?
    attr_accessor :id, :body, :question_id, :user_id, :parent_reply_id

    def self.find_by_id(id)
        look_up = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM 
                replies
            WHERE
                id = ?
        SQL
        return nil unless look_up.length > 0

        Reply.new(look_up.first)
    end

    def self.find_by_user_id(user_id)
         look_up = QuestionDBConnection.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM 
                replies
            WHERE
                user_id = ?
        SQL
        return nil unless look_up.length > 0

        look_up.map {|data| Reply.new(data) }
    end

    def self.find_by_question_id(question_id)
        look_up = QuestionDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM 
                replies
            WHERE
                question_id = ?
        SQL
        return nil unless look_up.length > 0

        look_up.map {|data| Reply.new(data) }
    end

    def self.find_by_parent_id(parent_reply_id)
        look_up = QuestionDBConnection.instance.execute(<<-SQL, parent_reply_id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
        return nil unless look_up.length > 0 

        look_up.map {|data| Reply.new(data)}
    end

    def initialize(options)
        @id = options['id']
        @body = options['body']
        @user_id = options['user_id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
    end

    def author
        User.find_by_id(user_id)
    end

    def question
        Question.find_by_id(self.question_id)
    end

    def parent_reply
        Reply.find_by_id(self.parent_reply_id)
    end

    def child_reply
        Reply.find_by_parent_id(self.id)
    end

end

class Question_like
    attr_accessor :id, :user_id, :question_id

    def self.find_by_id(id)
        look_up = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM 
                question_likes
            WHERE
                id = ?
        SQL
        return nil unless look_up.length > 0

        Question_like.new(look_up.first)
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

end